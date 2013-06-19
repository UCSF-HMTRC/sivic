/*
 *  Copyright © 2009-2011 The Regents of the University of California.
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
 */



#include <sivicProcessingWidget.h>
#include <vtkSivicController.h>

vtkStandardNewMacro( sivicProcessingWidget );
vtkCxxRevisionMacro( sivicProcessingWidget, "$Revision$");


/*! 
 *  Constructor
 */
sivicProcessingWidget::sivicProcessingWidget()
{
    this->phaseSlider = NULL;
    this->linearPhaseSlider = NULL;
    this->phaser = svkPhaseSpec::New();
    this->phaseAllVoxelsButton = NULL;
    this->phaseAllChannelsButton = NULL;
    this->fftButton = NULL;
    this->phaseButton = NULL;
    this->phasePivotEntry = NULL;
    this->phaseChangeInProgress = 0;
    this->progressCallback = vtkCallbackCommand::New();
    this->progressCallback->SetCallback( UpdateProgress );
    this->progressCallback->SetClientData( (void*)this );


}


/*! 
 *  Destructor
 */
sivicProcessingWidget::~sivicProcessingWidget()
{

    if( this->phaseSlider != NULL ) {
        this->phaseSlider->Delete();
        this->phaseSlider = NULL;
    }

    if( this->linearPhaseSlider != NULL ) {
        this->linearPhaseSlider->Delete();
        this->linearPhaseSlider = NULL;
    }

    if( this->phaser != NULL ) {
        this->phaser->Delete();
        this->phaser = NULL;
    }

    if( this->fftButton != NULL ) {
        this->fftButton->Delete();
        this->fftButton= NULL;
    }

    if( this->phaseButton != NULL ) {
        this->phaseButton->Delete();
        this->phaseButton= NULL;
    }

    if( this->phasePivotEntry != NULL ) {
        this->phasePivotEntry->Delete();
        this->phasePivotEntry= NULL;
    }

}


/*! 
 *  Method in superclass to be overriden to add our custom widgets.
 */
void sivicProcessingWidget::CreateWidget()
{
/*  This method will create our main window. The main window is a 
    vtkKWCompositeWidget with a vtkKWRendWidget. */

    // Check if already created
    if ( this->IsCreated() )
    {
        vtkErrorMacro(<< this->GetClassName() << " already created");
        return;
    }

    // Call the superclass to create the composite widget container
    this->Superclass::CreateWidget();

    this->phaseSlider = vtkKWScaleWithEntry::New();
    this->phaseSlider->SetParent(this);
    this->phaseSlider->Create();
    this->phaseSlider->SetEntryWidth( 4 );
    this->phaseSlider->SetOrientationToHorizontal();
    this->phaseSlider->SetLabelText("Zero Phase");
    this->phaseSlider->SetLabelWidth( 10 );
    this->phaseSlider->SetValue(0);
    this->phaseSlider->SetRange( -180, 180 );
    this->phaseSlider->SetBalloonHelpString("Adjusts the phase of the spectroscopic data.");
    this->phaseSlider->EnabledOff();
    this->phaseSlider->SetEntryPositionToRight();
    this->phaseSlider->SetLabelPositionToLeft();

    this->linearPhaseSlider = vtkKWScaleWithEntry::New();
    this->linearPhaseSlider->SetParent(this);
    this->linearPhaseSlider->Create();
    this->linearPhaseSlider->SetEntryWidth( 4 );
    this->linearPhaseSlider->SetOrientationToHorizontal();
    this->linearPhaseSlider->SetLabelText("Linear Phase");
    this->linearPhaseSlider->SetLabelWidth( 10 );
    this->linearPhaseSlider->SetValue(0);
    this->linearPhaseSlider->SetRange( -2048, 2048 );
    this->linearPhaseSlider->SetResolution( 0.1 );
    this->linearPhaseSlider->SetBalloonHelpString("Adjusts the phase of the spectroscopic data.");
    this->linearPhaseSlider->EnabledOff();
    this->linearPhaseSlider->SetEntryPositionToRight();
    this->linearPhaseSlider->SetLabelPositionToLeft();


    vtkKWCheckButtonSet* checkButtons = vtkKWCheckButtonSet::New();
    checkButtons->SetParent( this );
    checkButtons->PackHorizontallyOn( );
    checkButtons->ExpandWidgetsOn( );
    checkButtons->Create();

    this->phaseAllVoxelsButton = checkButtons->AddWidget(0);
    this->phaseAllVoxelsButton->SetParent(this);
    this->phaseAllVoxelsButton->Create();
    this->phaseAllVoxelsButton->EnabledOff();
    this->phaseAllVoxelsButton->SetText("Apply to All Voxels");
    this->phaseAllVoxelsButton->SelectedStateOn();

    this->phaseAllChannelsButton = checkButtons->AddWidget(1);
    this->phaseAllChannelsButton->SetParent(this);
    this->phaseAllChannelsButton->Create();
    this->phaseAllChannelsButton->EnabledOff();
    this->phaseAllChannelsButton->SetText("Apply to All Channels");
    this->phaseAllChannelsButton->SelectedStateOff();

    
    this->fftButton = vtkKWPushButton::New();
    this->fftButton->SetParent( this );
    this->fftButton->Create( );
    this->fftButton->EnabledOff();
    this->fftButton->SetText( "Reconstruct");
    this->fftButton->SetBalloonHelpString("Prototype Single Voxel FFT.");

    this->phaseButton = vtkKWPushButton::New();
    this->phaseButton->SetParent( this );
    this->phaseButton->Create( );
    this->phaseButton->EnabledOff();
    this->phaseButton->SetText( "Phase On Water");
    this->phaseButton->SetBalloonHelpString("Prototype Auto Phasing.");

    this->phasePivotEntry = vtkKWEntryWithLabel::New();
    this->phasePivotEntry->GetLabel()->SetText("Pivot Point ");
    this->phasePivotEntry->GetWidget()->SetWidth(5);
    this->phasePivotEntry->SetParent( this );
    this->phasePivotEntry->Create( );
    this->phasePivotEntry->EnabledOff();
    this->phasePivotEntry->SetLabelWidth(10);
    this->phasePivotEntry->GetWidget()->SetRestrictValueToInteger();
    this->phasePivotEntry->SetLabelPositionToLeft();

    this->Script("grid %s -row 0 -column 0 -columnspan 6 -sticky nwes", this->phaseSlider->GetWidgetName() );
    this->Script("grid %s -row 1 -column 0 -columnspan 6 -sticky nwes", this->linearPhaseSlider->GetWidgetName() );
    this->Script("grid %s -row 2 -column 0 -columnspan 2 -sticky nwes ", this->phasePivotEntry->GetWidgetName() );
    this->Script("grid %s -row 2 -column 2 -columnspan 4 -sticky nwes", checkButtons->GetWidgetName() );
    this->Script("grid %s -row 3 -column 0 -columnspan 3 -sticky we -padx 4 -pady 2 ", this->fftButton->GetWidgetName() );
    this->Script("grid %s -row 3 -column 3 -columnspan 3 -sticky we -padx 4 -pady 2 ", this->phaseButton->GetWidgetName() );

    this->Script("grid rowconfigure %s 0  -weight 2", this->GetWidgetName() );
    this->Script("grid rowconfigure %s 1  -weight 2", this->GetWidgetName() );
    this->Script("grid rowconfigure %s 2  -weight 1", this->GetWidgetName() );
    this->Script("grid rowconfigure %s 3  -weight 2", this->GetWidgetName() );

    this->Script("grid columnconfigure %s 0 -weight 1", this->GetWidgetName() );
    this->Script("grid columnconfigure %s 1 -weight 1", this->GetWidgetName() );
    this->Script("grid columnconfigure %s 2 -weight 1", this->GetWidgetName() );
    this->Script("grid columnconfigure %s 3 -weight 1", this->GetWidgetName() );
    this->Script("grid columnconfigure %s 4 -weight 1", this->GetWidgetName() );
    this->Script("grid columnconfigure %s 5 -weight 1", this->GetWidgetName() );

    this->AddCallbackCommandObserver(
        this->overlayController->GetRWInteractor(), vtkCommand::SelectionChangedEvent );
    this->AddCallbackCommandObserver(
        this->plotController->GetRWInteractor(), vtkCommand::SelectionChangedEvent );
    this->AddCallbackCommandObserver(
        this->phaseSlider, vtkKWScale::ScaleValueChangedEvent );
    this->AddCallbackCommandObserver(
        this->phaseSlider, vtkKWScale::ScaleValueChangingEvent );
    this->AddCallbackCommandObserver(
        this->phaseSlider, vtkKWScale::ScaleValueStartChangingEvent );
    this->AddCallbackCommandObserver(
        this->linearPhaseSlider, vtkKWScale::ScaleValueChangedEvent );
    this->AddCallbackCommandObserver(
        this->linearPhaseSlider, vtkKWScale::ScaleValueChangingEvent );
    this->AddCallbackCommandObserver(
        this->linearPhaseSlider, vtkKWScale::ScaleValueStartChangingEvent );
    this->AddCallbackCommandObserver(
        this->phaseAllVoxelsButton, vtkKWCheckButton::SelectedStateChangedEvent );
    this->AddCallbackCommandObserver(
        this->phaseAllChannelsButton, vtkKWCheckButton::SelectedStateChangedEvent );
    this->AddCallbackCommandObserver(
        this->fftButton, vtkKWPushButton::InvokedEvent );
    this->AddCallbackCommandObserver(
        this->phaseButton, vtkKWPushButton::InvokedEvent );
    this->AddCallbackCommandObserver(
        this->phasePivotEntry->GetWidget(), vtkKWEntry::EntryValueChangedEvent );

    checkButtons->Delete();

}


/*! 
 *  Method responds to callbacks setup in CreateWidget
 */
void sivicProcessingWidget::ProcessCallbackCommandEvents( vtkObject *caller, unsigned long event, void *calldata )
{
    // Respond to a selection change in the overlay view
    if (  caller == this->plotController->GetRWInteractor() && event == vtkCommand::SelectionChangedEvent ) {

        this->SetPhaseUpdateExtent();

    // Respond to a selection change in the plot grid view 
    } else if (  caller == this->overlayController->GetRWInteractor() && event == vtkCommand::SelectionChangedEvent ) {

        this->SetPhaseUpdateExtent();
    } else if( caller == this->phaseSlider ) {
        switch ( event ) {
            case vtkKWScale::ScaleValueChangedEvent:
                this->phaseChangeInProgress = 0;
                this->UpdatePhaseSliderBindings();
                break;
            case vtkKWScale::ScaleValueChangingEvent:
                this->phaser->SetPhase0( this->phaseSlider->GetValue() );
                this->phaser->Update();
                if( !this->phaseChangeInProgress ) {
                    this->UpdatePhaseSliderBindings();
                }
                break;
            case vtkKWScale::ScaleValueStartChangingEvent:
                this->phaseChangeInProgress = 1;
                break;
            default:
                cout << "Got a unknown event!" << endl;
        }
    } else if( caller == this->linearPhaseSlider ) {
        switch ( event ) {
            case vtkKWScale::ScaleValueChangedEvent:
                this->phaseChangeInProgress = 0;
                this->UpdateLinearPhaseSliderBindings();
                break;
            case vtkKWScale::ScaleValueChangingEvent:
                this->phaser->SetLinearPhase( (-this->linearPhaseSlider->GetValue())/360.0 );
                this->phaser->Update();
                if( !this->phaseChangeInProgress ) {
                    this->UpdateLinearPhaseSliderBindings();
                }
                break;
            case vtkKWScale::ScaleValueStartChangingEvent:
                this->phaseChangeInProgress = 1;
                break;
            default:
                cout << "Got a unknown event!" << endl;
        }
    } else if( caller == this->phaseAllChannelsButton && event == vtkKWCheckButton::SelectedStateChangedEvent) {
        this->SetPhaseUpdateExtent();
    } else if( caller == this->phaseAllVoxelsButton && event == vtkKWCheckButton::SelectedStateChangedEvent) {
        this->SetPhaseUpdateExtent();
    } else if( caller == this->fftButton && event == vtkKWPushButton::InvokedEvent ) {
        this->ExecuteRecon();
    } else if( caller == this->phaseButton && event == vtkKWPushButton::InvokedEvent ) {
        this->ExecutePhase();
    } else if( caller == this->phasePivotEntry->GetWidget() ) {

    	this->phaser->SetLinearPhasePivot( this->phasePivotEntry->GetWidget()->GetValueAsInt() );
    }
    this->Superclass::ProcessCallbackCommandEvents(caller, event, calldata);
}


/*!
 *  Sets the correct update extent for phasing
 */
void sivicProcessingWidget::SetPhaseUpdateExtent()
{
    int* start = new int[3];
    int* end = new int[3];
    start[0] = -1;
    start[1] = -1;
    start[2] = -1;
    end[0] = -1;
    end[1] = -1;
    end[2] = -1;

    if ( this->phaseAllChannelsButton->GetSelectedState() ) {
        this->phaser->PhaseAllChannels();
    } else if(  this->model->DataExists("SpectroscopicData") ) {
            this->phaser->SetChannel( this->plotController->GetVolumeIndex( svkMrsImageData::CHANNEL ) );
    }

    if ( this->phaseAllVoxelsButton->GetSelectedState() ) {
        this->phaser->SetUpdateExtent(start, end );
    } else {
        int* range = new int[2];
        range = this->plotController->GetTlcBrc();
        this->model->GetDataObject("SpectroscopicData")->GetIndexFromID(range[0], start);
        this->model->GetDataObject("SpectroscopicData")->GetIndexFromID(range[1], end);
        this->phaser->SetUpdateExtent(start, end );
    }
    delete[] start;
    delete[] end;
}


/*!
 *  Updates/Adds keyboard bindings to the phase slider when it is in focus.
 */
void sivicProcessingWidget::UpdatePhaseSliderBindings()
{
    stringstream increment;
    stringstream decrement;
    increment << "SetValue " << this->phaseSlider->GetValue() + this->phaseSlider->GetResolution();
    decrement << "SetValue " << this->phaseSlider->GetValue() - this->phaseSlider->GetResolution();
    this->phaseSlider->RemoveBinding( "<Left>");
    this->phaseSlider->AddBinding( "<Left>", this->phaseSlider, decrement.str().c_str() );
    this->phaseSlider->RemoveBinding( "<Right>");
    this->phaseSlider->AddBinding( "<Right>", this->phaseSlider, increment.str().c_str() );
    this->phaseSlider->Focus(); 
}


/*!
 *  Updates/Adds keyboard bindings to the phase slider when it is in focus.
 */
void sivicProcessingWidget::UpdateLinearPhaseSliderBindings()
{
    stringstream increment;
    stringstream decrement;
    increment << "SetValue " << this->linearPhaseSlider->GetValue() + this->linearPhaseSlider->GetResolution();
    decrement << "SetValue " << this->linearPhaseSlider->GetValue() - this->linearPhaseSlider->GetResolution();
    this->linearPhaseSlider->RemoveBinding( "<Left>");
    this->linearPhaseSlider->AddBinding( "<Left>", this->linearPhaseSlider, decrement.str().c_str() );
    this->linearPhaseSlider->RemoveBinding( "<Right>");
    this->linearPhaseSlider->AddBinding( "<Right>", this->linearPhaseSlider, increment.str().c_str() );
    this->linearPhaseSlider->Focus();
}


/*!
 *  Executes the FFT in place.
 */
void sivicProcessingWidget::ExecuteFFT() 
{
    svkImageData* data = this->model->GetDataObject("SpectroscopicData");
    if( data != NULL ) {
        // We'll turn the renderer off to avoid rendering intermediate steps
        this->plotController->GetView()->TurnRendererOff(svkPlotGridView::PRIMARY);
        svkMrsImageFFT* imageFFT = svkMrsImageFFT::New();
        imageFFT->SetInput( data );
        imageFFT->Update();
        data->Modified();
        imageFFT->Delete();
        bool useFullFrequencyRange = 1;
        bool useFullAmplitudeRange = 1;
        bool resetAmplitude = 1;
        bool resetFrequency = 1;
        this->sivicController->ResetRange( useFullFrequencyRange, useFullAmplitudeRange, 
                                           resetAmplitude, resetFrequency );
        this->sivicController->EnableWidgets( );
        this->plotController->GetView()->TurnRendererOn(svkPlotGridView::PRIMARY);
        this->plotController->GetView()->Refresh();
    }

}


/*!
 *  Executes the Recon.
 */
void sivicProcessingWidget::ExecuteRecon() 
{
    svkImageData* data = this->model->GetDataObject("SpectroscopicData");
    if( data != NULL ) {

        svkMrsImageFFT* spatialRFFT = svkMrsImageFFT::New();

        spatialRFFT->SetInput( data );
        spatialRFFT->SetFFTDomain( svkMrsImageFFT::SPATIAL );
        spatialRFFT->SetFFTMode( svkMrsImageFFT::REVERSE );
        spatialRFFT->SetPreCorrectCenter( true );
        spatialRFFT->SetPostCorrectCenter( true );
        spatialRFFT->AddObserver(vtkCommand::ProgressEvent, progressCallback);
        this->GetApplication()->GetNthWindow(0)->SetStatusText("Executing Spatial Recon...");
        spatialRFFT->Update();
        spatialRFFT->RemoveObserver( progressCallback );

        svkMrsImageFFT* spectralFFT = svkMrsImageFFT::New();
        spectralFFT->AddObserver(vtkCommand::ProgressEvent, progressCallback);
        this->GetApplication()->GetNthWindow(0)->SetStatusText("Executing FFT...");
        spectralFFT->SetInput( spatialRFFT->GetOutput() );
        spectralFFT->SetFFTDomain( svkMrsImageFFT::SPECTRAL );
        spectralFFT->SetFFTMode( svkMrsImageFFT::FORWARD );
        spectralFFT->Update();
        data->Modified();
        data->Update();
        spectralFFT->RemoveObserver( progressCallback);
        

        bool useFullFrequencyRange = 1;
        bool useFullAmplitudeRange = 1;
        bool resetAmplitude = 1;
        bool resetFrequency = 1;
        //this->sivicController->ResetRange( useFullFrequencyRange, useFullAmplitudeRange, 
        //                                   resetAmplitude, resetFrequency );
        string stringFilename = "Result";
        this->sivicController->Open4DImage( data, stringFilename);
        this->sivicController->EnableWidgets( );

        // We are resetting the input to make sure the actors get updated

        //this->plotController->SetInput(data);
        //this->plotController->GetView()->TurnRendererOn(svkPlotGridView::PRIMARY);
        //this->plotController->GetView()->Refresh();
        spatialRFFT->Delete();
        spectralFFT->Delete();
        this->GetApplication()->GetNthWindow(0)->GetProgressGauge()->SetValue( 0.0 );
        this->GetApplication()->GetNthWindow(0)->SetStatusText(" Done ");
    }

}


/*!
 *  Executes the Phasing.
 */
void sivicProcessingWidget::ExecutePhase() 
{
    svkImageData* data = this->model->GetDataObject("SpectroscopicData");
    if( data != NULL ) {
        // We'll turn the renderer off to avoid rendering intermediate steps
        this->plotController->GetView()->TurnRendererOff(svkPlotGridView::PRIMARY);
        svkMultiCoilPhase* multiCoilPhase = svkMultiCoilPhase::New();
        multiCoilPhase->AddObserver(vtkCommand::ProgressEvent, progressCallback);
        multiCoilPhase->SetInput( data );
        multiCoilPhase->Update();
        data->Modified();
        multiCoilPhase->RemoveObserver( progressCallback);
        multiCoilPhase->Delete();
        bool useFullFrequencyRange = 0;
        bool useFullAmplitudeRange = 1;
        bool resetAmplitude = 1;
        bool resetFrequency = 0;
        string stringFilename = "PhasedData";
        this->sivicController->Open4DImage( data, stringFilename);
        this->sivicController->EnableWidgets( );
        //this->sivicController->ResetRange( useFullFrequencyRange, useFullAmplitudeRange, 
        //                                   resetAmplitude, resetFrequency );
        this->plotController->GetView()->TurnRendererOn(svkPlotGridView::PRIMARY);
        this->plotController->GetView()->Refresh();
        this->GetApplication()->GetNthWindow(0)->GetProgressGauge()->SetValue( 0.0 );
        this->GetApplication()->GetNthWindow(0)->SetStatusText(" Done ");
    }
}


void sivicProcessingWidget::InitializePhaser()
{
    if( this->phaser != NULL ) {
        this->phaser->Delete();
    }
    this->phaser = svkPhaseSpec::New();
    if( this->model->DataExists("SpectroscopicData") ) {
        svkImageData* data = this->model->GetDataObject("SpectroscopicData");
        this->phaser->SetInput( data );
        this->SetPhaseUpdateExtent();
    }
    this->phaseSlider->SetValue(0.0);
    this->linearPhaseSlider->SetValue(0.0);

}

void sivicProcessingWidget::UpdateProgress(vtkObject* subject, unsigned long, void* thisObject, void* callData)
{
    static_cast<vtkKWCompositeWidget*>(thisObject)->GetApplication()->GetNthWindow(0)->GetProgressGauge()->SetValue( 100.0*(*(double*)(callData)) );
    static_cast<vtkKWCompositeWidget*>(thisObject)->GetApplication()->GetNthWindow(0)->SetStatusText(
                  static_cast<vtkAlgorithm*>(subject)->GetProgressText() );

}

