#package require Tk
#package require Img

# delete the namespace if exists
catch {namespace delete vwWidget}

namespace eval ::vwWidget {
  variable pngPath "PNGs"
  
  proc isSimulationStarted {} {
    variable tbEnt

    return [expr {[runStatus] != "nodesign" && [find instances -bydu -nodu $tbEnt] == "/$tbEnt"}]
  }

  proc getState {} {
    variable tbEnt
    
    return [examine "sim:/$tbEnt/DUT/state"]
  }

  proc setFlowChartImg {} {
    if [isSimulationStarted] {
      set state [getState]
    } else {
      set state IDLE
    }

    set imgFile "$::vwWidget::pngPath/$state.png"
    image create photo flowChartImg -file $imgFile
  }

  proc enableOrDisableButtons {} {
    if [isSimulationStarted] {
      .vwWidget.waveBtn   configure -state normal
      .vwWidget.runOneBtn configure -state normal
      .vwWidget.runAllBtn configure -state normal
    } else {
      .vwWidget.waveBtn   configure -state disable
      .vwWidget.runOneBtn configure -state disable
      .vwWidget.runAllBtn configure -state disable
    }
  }

  proc registerWhenCallback {} {
    if [isSimulationStarted] {
      when -label stateChangeWhen {DUT/state} {
        set state [::vwWidget::getState]
        echo "$now $UserTimeUnit - Current state is: $state"
        ::vwWidget::setFlowChartImg
        
        if {[regexp $::vwWidget::destStateExp $state]} {
          stop
        }
        
      }
    }
  }

  proc startTB {} {
    variable tbLib "work"
    variable tbEnt "traffic_lights_tb"

    # if the simulation is already ungoing
    if [isSimulationStarted] {
      echo "Restarting the simulation"
      restart -force

    } else {
      echo "Starting a new simulation"
      vsim -gui -onfinish stop -msgmode both -voptargs=+acc "$tbLib.$tbEnt"

    }

    # log all signalls, even if the waveform isn't open yet
    log * -r

    # update window
    setFlowChartImg
    enableOrDisableButtons
    registerWhenCallback

    # close any open waveform window
    noview wave

    # keep the window on top
    focus .vwWidget

  }

  proc quitTB {} {
    echo "Quitting the simulation"
    quit -sim

    # update window
    setFlowChartImg
    enableOrDisableButtons

    # keep the window on top
    focus .vwWidget

  }

  proc createProject {} {

    set projectPath modelsim_proj
    set projectName vw_tcl_widget
    set srcFileName traffic_lights

    # create/open project
    if {[file exists "$projectPath/$projectName.mpf"]} {
      project open "$projectPath/$projectName.mpf"

    } else {
      # create the modelsim directory
      file mkdir $projectPath

      project new $projectPath $projectName

      # add sources
      echo "adding files"
      project addfile "../srcs/$srcFileName.vhd"
      project addfile "../srcs/$srcFileName\_tb.vhd"
    }

    # update PNG path
    variable pngPath "../PNGs"

	}
	
	proc compileFiles {} {

      createProject

      echo "Compilling VHDL files"
      project compileall
  }

  proc openWave {} {
    
    if {[lsearch [view] .main_pane.wave] == -1} {
      echo "Openning waveforms"
      do "../wave.do"

    } else {
      echo "Reopenning waveforms"
      noview wave
      do "../wave.do"
      focus .main_pane.wave

    }     
  }

  proc runOneState {} {
    # match any state name
    variable destStateExp {.*}

    echo "Running through the current DUT state"
    run -all
  }

  proc runAllState {} {
    # match a specific state name
    set currState [getState]
    variable destStateExp "^$currState\$"

    echo "Running through all DUT states"
    run -all
  }

  # close the widget if it's alreeady running
  catch {destroy .vwWidget}

  toplevel .vwWidget

  # clean up before exiting when the user closes the widget
  wm protocol .vwWidget WM_DELTET_WINDOW {
    destroy .vwWidget
  }

  # interaction with test bench
  variable tbLib "work"
  variable tbEnt "traffic_lights_tb"


  # communication variable
  variable destStateExp ""

  # header image widget
  image create photo headerImg -file "$pngPath/header.png"
  label .vwWidget.headerImg -image headerImg

  # button widgets
  button .vwWidget.startBtn   -width 30 -height 2 -text "Start the Simulation" -command ::vwWidget::startTB
  button .vwWidget.quitBtn    -width 30 -height 2 -text "Quit the Simulation" -command ::vwWidget::quitTB
  button .vwWidget.compileBtn -width 30 -height 2 -text "Compile VHDL files" -command ::vwWidget::compileFiles
  button .vwWidget.waveBtn    -width 30 -height 2 -text "Open Waveform" -command ::vwWidget::openWave
  button .vwWidget.runOneBtn  -width 30 -height 2 -text "Run One State" -command ::vwWidget::runOneState
  button .vwWidget.runAllBtn  -width 30 -height 2 -text "Run All States" -command ::vwWidget::runAllState

  # footer image widget
  image create photo flowChartImg -file "$pngPath/IDLE.png"
  label .vwWidget.flowChartImg -image flowChartImg

  # initialize buttons and footer image
  setFlowChartImg
  enableOrDisableButtons
  registerWhenCallback

  # add widgets to the window
  grid .vwWidget.headerImg    -row 0              -column 0  -columnspan 3
  grid .vwWidget.startBtn     -row 1 -pady {10 0} -column 0 -columnspan 1
  grid .vwWidget.quitBtn      -row 1 -pady {10 0} -column 1 -columnspan 1
  grid .vwWidget.compileBtn   -row 1 -pady {10 0} -column 2 -columnspan 1
  grid .vwWidget.waveBtn      -row 2 -pady 10     -column 0 -columnspan 1
  grid .vwWidget.runOneBtn    -row 2 -pady 10     -column 1 -columnspan 1
  grid .vwWidget.runAllBtn    -row 2 -pady 10     -column 2 -columnspan 1
  grid .vwWidget.flowChartImg -row 3              -column 0 -columnspan 3

}