/*
 *  Copyright © 2009-2010 The Regents of the University of California.
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
 *
 */

#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkActorCollection.h>
#include <svkImageReader2.h>
#include <svkImageReaderFactory.h>
#include <svkImageData.h>
#include <svkImageTopologyGenerator.h>
#include <vtkCollectionIterator.h>
#include <vtkCamera.h>

using namespace svk;
    
svkImageData* LoadFile( char* fileName );

int main ( int argc, char** argv )
{
    char* fileName = NULL;
    if( argc == 1 ) {
        cerr<<"Not enough input arguments."<<endl;
        return 1;
    } else if( argc == 2 ) {
        fileName = argv[1];
    } else if( argc > 2) {
        cerr<<"Too many input arguments."<<endl;
        return 1;
    } 
    /*
    svkImageData* data = LoadFile( fileName );
    data->Update();
    data->Delete();
    */ 
      
    vtkRenderer* ren = vtkRenderer::New();
    vtkRenderWindow* window = vtkRenderWindow::New();
    vtkRenderWindowInteractor* rwi = vtkRenderWindowInteractor::New();
    vtkCollectionIterator* myIterator = vtkCollectionIterator::New();
    window->SetInteractor( rwi );
    window->AddRenderer( ren );
    svkImageData* data = LoadFile( fileName );
    vtkActorCollection* topology = data->GetTopoActorCollection(0);
   
    myIterator->SetCollection(topology);
    myIterator->InitTraversal();
    while( !myIterator->IsDoneWithTraversal() ) {
        ren->AddActor( vtkActor::SafeDownCast( myIterator->GetCurrentObject() ) );
        myIterator->GoToNextItem();
    }
    
    ren->GetActiveCamera()->SetParallelProjection(1); 
    window->Render();
    vtkActorCollection* selectionBoxCollection = data->GetTopoActorCollection(1);
    selectionBoxCollection->InitTraversal();
    vtkActor* selectionBox = selectionBoxCollection->GetNextActor();
    ren->AddActor( selectionBox );
    ren->ResetCamera(); 
    
    rwi->Start();
    
    ren->Delete();
    window->Delete();
    rwi->Delete();
    
    cout<<"Topology:"<<endl<<*topology<<endl;
    myIterator->Delete();
    cout<<"data:"<<endl<<*data<<endl;
    data->Delete();
    
    
    fileName = NULL;
   
    return 0;
    
}

svkImageData* LoadFile( char* fileName )
{
    svkImageData* myData;
    svkImageReaderFactory* readerFactory = svkImageReaderFactory::New();
    svkImageReader2* reader = readerFactory->CreateImageReader2(fileName);
    readerFactory->Delete();

    if (reader == NULL) {
        cerr << "Can not determine appropriate reader for: " << fileName << endl;
        exit(1);
    }

    reader->SetFileName( fileName );
    reader->Update();
    myData = reader->GetOutput();
    myData->Register( NULL );
    reader->Delete();
    return myData;
}
