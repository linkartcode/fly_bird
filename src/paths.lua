-- Contains all paths to required files

-- https://github.com/Ulydev/push
push = require 'libs/push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'libs/class'

-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'state_machine.StateMachine'

require 'state_machine.states.BaseState'

require 'state_machine.states.titleState'
require 'state_machine.states.countdownState'
require 'state_machine.states.playState'
require 'state_machine.states.scoreState'

require 'objects.Bird'
require 'objects.Pipe'
require 'objects.PipePair'
