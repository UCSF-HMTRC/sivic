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


#include <svkImageThreshold.h>


using namespace svk;


vtkCxxRevisionMacro(svkImageThreshold, "$Rev$");
vtkStandardNewMacro(svkImageThreshold);


/*!
 *
 */
svkImageThreshold::svkImageThreshold()
{
#if VTK_DEBUG_ON
    this->DebugOn();
#endif

    vtkDebugMacro(<< this->GetClassName() << "::" << this->GetClassName() << "()");

    // We have to call this in the constructor. Internally this will call SetupParameterPorts
    this->SetNumberOfInputPorts(5);
    this->xmlInterpreter->InitializeInputPort( INPUT_IMAGE, "INPUT_IMAGE", svkXMLInputInterpreter::SVK_MR_IMAGE_DATA);
    this->xmlInterpreter->InitializeInputPort( MASK_SERIES_DESCRIPTION, "MASK_SERIES_DESCRIPTION", svkXMLInputInterpreter::SVK_STRING);
    this->xmlInterpreter->InitializeInputPort( MASK_OUTPUT_VALUE, "MASK_OUTPUT_VALUE", svkXMLInputInterpreter::SVK_INT);
    this->xmlInterpreter->InitializeInputPort( THRESHOLD_MIN, "THRESHOLD_MIN", svkXMLInputInterpreter::SVK_DOUBLE);
    this->xmlInterpreter->InitializeInputPort( THRESHOLD_MAX, "THRESHOLD_MAX", svkXMLInputInterpreter::SVK_DOUBLE);
}


/*!
 *
 */
svkImageThreshold::~svkImageThreshold()
{
    vtkDebugMacro(<<this->GetClassName()<<"::~svkImageThreshold()");
}


/*!
 * Utility setter for input port parameter.
 */
void svkImageThreshold::SetThresholdMax( double max )
{
    this->xmlInterpreter->SetDoubleInputPortValue( THRESHOLD_MAX, max);
}


/*!
 * Utility getter for input port parameter.
 */
double svkImageThreshold::GetThresholdMax( )
{
    return this->xmlInterpreter->GetDoubleInputPortValue( THRESHOLD_MAX );
}


/*!
 * Utility setter for input port parameter.
 */
void svkImageThreshold::SetThresholdMin( double min )
{
    this->xmlInterpreter->SetDoubleInputPortValue( THRESHOLD_MIN, min);
}


/*!
 * Utility getter for input port parameter.
 */
double svkImageThreshold::GetThresholdMin( )
{
    return this->xmlInterpreter->GetDoubleInputPortValue( THRESHOLD_MIN );
}


/*!
 * Utility setter for input port parameter.
 */
void svkImageThreshold::SetMaskOutputValue( int value )
{
    this->xmlInterpreter->SetIntInputPortValue( MASK_OUTPUT_VALUE, value);
}


/*!
 * Utility getter for input port parameter.
 */
int svkImageThreshold::GetMaskOutputValue( )
{
    return this->xmlInterpreter->GetIntInputPortValue( MASK_OUTPUT_VALUE );
}


/*!
 * Utility setter for input port parameter.
 */
void svkImageThreshold::SetMaskSeriesDescription( string description )
{
    this->xmlInterpreter->SetStringInputPortValue( MASK_SERIES_DESCRIPTION, description);
}


/*!
 * Utility getter for input port parameter.
 */
string svkImageThreshold::GetMaskSeriesDescription( )
{
    return this->xmlInterpreter->GetStringInputPortValue( MASK_SERIES_DESCRIPTION );
}


/*!
 *  RequestData pass the input through the algorithm, and copies the dcos and header
 *  to the output. 
 */
int svkImageThreshold::RequestData( vtkInformation* request,
                                    vtkInformationVector** inputVector,
                                    vtkInformationVector* outputVector )
{
    double max = this->GetThresholdMax();
    double min = this->GetThresholdMin();
    int value = this->GetMaskOutputValue();
    string description = this->GetMaskSeriesDescription();

    //cout << "REQUEST DATA USING PARAMETERS:" << endl;
    cout << "max   = " << max << endl;
    cout << "min   = " << min <<  endl;
    //cout << "desc  = " << description << endl;
    //cout << "value = " << value << endl;

    vtkImageThreshold* threshold = vtkImageThreshold::New();
    threshold->SetOutValue(0);
    threshold->SetInValue(value);
    threshold->ThresholdBetween( min, max );

    svkImageAlgorithmExecuter* executer = svkImageAlgorithmExecuter::New();
    executer->SetAlgorithm( threshold );

    // Set the input of the vtk algorithm to be the input of the executer
    executer->SetInput(this->GetImageDataInput(0));

    // Update the vtk algorithm
    executer->Update();

    // Copy the output of the vtk algorithm
    this->GetOutput()->DeepCopy( executer->GetOutput() );
    this->GetOutput()->CopyDcos( this->GetImageDataInput(0) );
    this->GetOutput()->GetDcmHeader()->SetValue("SeriesDescription", description );
    threshold->Delete();
    executer->Delete();
    return 1; 
}