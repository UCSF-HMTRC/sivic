/*
 *  Copyright © 2009-2014 The Regents of the University of California.
 *  All Rights Reserved.
 *
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted provided that the following conditions are met:
 *  •   Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 *  •   Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 *  •   None of the names of any campus of the University of California, the name 
 *      "The Regents of the University of California," or the names of any of its 
 *      contributors may be used to endorse or promote products derived from this 
 *      software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 *  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 *  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 *  OF SUCH DAMAGE.
 */

/*
 *  $URL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Authors:
 *      Jason C. Crane, Ph.D.
 *      Beck Olson
 */


#include <svkImageAlgorithmPipeline.h>

using namespace svk;

vtkCxxRevisionMacro(svkImageAlgorithmPipeline, "$Rev$");
vtkStandardNewMacro(svkImageAlgorithmPipeline);

//! Constructor
svkImageAlgorithmPipeline::svkImageAlgorithmPipeline()
{
    this->SetNumberOfInputPorts(1);
    this->SetNumberOfOutputPorts(0);
    this->GetPortMapper()->InitializeInputPort( PIPELINE, "pipeline", svkAlgorithmPortMapper::SVK_XML);
    this->GetPortMapper()->SetXMLInputPortPrefix("svk");
}


//! Destructor
svkImageAlgorithmPipeline::~svkImageAlgorithmPipeline()
{
}


/*!
 *  Creates the algorithm pipeline and executes it.
 */
int svkImageAlgorithmPipeline::RequestData( vtkInformation* request,
                                    vtkInformationVector** inputVector,
                                    vtkInformationVector* outputVector )
{
    cout << "In RequestData!" << endl;
    vtkXMLDataElement* pipeline = this->GetPortMapper()->GetXMLInputPortValue(PIPELINE)->GetValue();
    if( pipeline != NULL ) {
        int numberOfFilters = pipeline->GetNumberOfNestedElements();
        // Let's initialize the algorithms...
        for( int i = 0; i < numberOfFilters; i++ ) {
            // Get the first algorithm
            vtkXMLDataElement* algorithm = pipeline->GetNestedElement(i);
            if( algorithm != NULL ) {
                this->InitializeAlgorithmForTag( algorithm );
            }
        }
        this->SetInputConnections( pipeline );
        this->ExecutePipeline( pipeline );
    }
    return 1;
}


/*!
 *  This method goes through all the algorithms in the pipeline and sets any input connections from
 *  the outputs stored in the idToPortMap hash.
 */
void svkImageAlgorithmPipeline::SetInputConnections( vtkXMLDataElement* pipeline )
{
        int numberOfFilters = pipeline->GetNumberOfNestedElements();
        // Second loop sets inputs to the algorithms
        for( int i = 0; i < numberOfFilters; i++ ) {
            vtkXMLDataElement* algorithmXML = pipeline->GetNestedElement(i);
            if( algorithmXML != NULL ) {
                cout << "tag pointer:" << algorithmXML << endl;
                cout << "Get algorithm for tag:" << endl;
                vtkIndent indent;
                algorithmXML->PrintXML(cout, indent);
                vtkAlgorithm* algorithm = this->xmlToAlgoMap[algorithmXML];
                cout << "algorithm: " << *algorithm << endl;
                cout << "Number of input ports for algorithm: " << algorithm->GetNumberOfInputPorts() << endl;
                for( int port = 0; port < algorithm->GetNumberOfInputPorts(); port++ ) {
                    string xmlTag;
                    if( algorithm->IsA("svkImageReader2")) {
                        xmlTag = "svkArgument:FILENAME";
                    } else if( algorithm->IsA("svkImageAlgorithmWithPortMapper")) {
                        xmlTag = svkImageAlgorithmWithPortMapper::SafeDownCast(algorithm)->GetPortMapper()->GetXMLTagForInputPort(port);
                    } else if( algorithm->IsA("svkImageWriter")) {
                        xmlTag = "svkArgument:INPUT_IMAGE";
                    }
                    vtkXMLDataElement* inputElement = algorithmXML->FindNestedElementWithName(xmlTag.c_str());
                    if( inputElement!= NULL && inputElement->GetAttribute("input_image_id") != NULL ) {
                        cout << "Setting input connection for: " << algorithm << endl;
                        algorithm->SetInputConnection( port, this->idToPortMap[inputElement->GetAttribute("input_image_id")]);
                    }
                }
            }
        }
}


/*!
 *  This method actually goes through and executes the components of the pipeline.
 */
void svkImageAlgorithmPipeline::ExecutePipeline( vtkXMLDataElement* pipeline )
{
        int numberOfFilters = pipeline->GetNumberOfNestedElements();
        // Second loop is to set the inputs and to run the algorithms.
        for( int i = 0; i < numberOfFilters; i++ ) {
            vtkXMLDataElement* algorithmXML = pipeline->GetNestedElement(i);
            if( algorithmXML != NULL ) {
                cout << "Algo name = " << algorithmXML->GetName() << endl;
                if(string(algorithmXML->GetName()) == "svkAlgorithm:svkImageWriter") {

                    cout << "Executing algorithm: " <<  xmlToAlgoMap[algorithmXML] << endl;
                    vtkImageWriter::SafeDownCast(xmlToAlgoMap[algorithmXML])->GetInputConnection(0,0)->GetProducer()->Update();
                    vtkImageWriter::SafeDownCast(xmlToAlgoMap[algorithmXML])->Write();
                } else {
                    xmlToAlgoMap[algorithmXML]->Update();
                }
            }
        }
}


/*!
 * Factory method for getting the algorithms by class name.
 */
void svkImageAlgorithmPipeline::InitializeAlgorithmForTag( vtkXMLDataElement* tag )
{
    //TODO: Create algorithm factory class like svkImageReaderFactory
    cout << "Filter name:" << tag->GetName() << endl;
    svkAlgorithmPortMapper* portMapper = NULL;
    if(string(tag->GetName()) == "svkAlgorithm:svkImageReader2") {
        svkImageReaderFactory* readerFactory = svkImageReaderFactory::New();
        vtkXMLDataElement* filenameElement = tag->FindNestedElementWithName("svkArgument:FILENAME");
        string filename = filenameElement->GetCharacterData();
        svkImageReader2* reader = svkImageReader2::SafeDownCast(readerFactory->CreateImageReader2(filename.c_str()));
        if( reader != NULL ) {
            reader->SetFileName( filename.c_str() );
            this->xmlToAlgoMap[tag] = reader;
            reader->Register(this);
            vtkXMLDataElement* outputElement = tag->FindNestedElementWithName("svkArgument:OUTPUT");
            // Let's save the output into the idToPortMap hash
            this->idToPortMap[outputElement->GetAttribute("output_image_id")] = reader->GetOutputPort(0);
            this->idToPortMap[outputElement->GetAttribute("output_image_id")]->Register(this);
        }
    } else if (string(tag->GetName()) == "svkAlgorithm:svkImageWriter") {
        vtkXMLDataElement* filenameElement = tag->FindNestedElementWithName("svkArgument:FILENAME");
        string filename = filenameElement->GetCharacterData();
        svkIdfVolumeWriter* writer = svkIdfVolumeWriter::New();
        writer->SetFileName(filename.c_str());
        this->xmlToAlgoMap[tag] = writer;
        cout << "Mapper xml " << tag << " to writer " << writer << endl;
        writer->Register(this);
    } else {
        svkImageAlgorithmWithPortMapper* algorithm = NULL;
        if( string(tag->GetName()) == "svkAlgorithm:svkImageThreshold") {
            algorithm = svkImageThreshold::New();
        } else {
            cout << "ERROR! Filter: " << tag->GetName() << " is not yet supported!" << endl;
        }
        if( algorithm != NULL ) {
            algorithm->SetInputPortsFromXML( tag );
            // Let's save a pointer to the algorithm initialized for this xml element
            this->xmlToAlgoMap[tag] = algorithm;
            algorithm->Register(this);
            portMapper = algorithm->GetPortMapper();
            for( int port = 0; port < portMapper->GetNumberOfOutputPorts(); port++ ) {
                string xmlTag = portMapper->GetXMLTagForOutputPort(port);
                vtkXMLDataElement* outputElement = tag->FindNestedElementWithName(xmlTag.c_str());
                // Let's save the output into the idToPortMap hash
                this->idToPortMap[outputElement->GetAttribute("output_image_id")] = portMapper->GetOutputPort(port);
                this->idToPortMap[outputElement->GetAttribute("output_image_id")]->Register(this);
            }
        }
    }
}
