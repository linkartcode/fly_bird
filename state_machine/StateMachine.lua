--[[
	StateMachine Class
	Author: Colton Ogden
	cogden@cs50.harvard.edu

	Code taken and edited from lessons in http://howtomakeanrpg.com

	Использование:
	Состояния создаются только по мере необходимости, чтобы сэкономить память и уменьшить количество ошибок очистки
	и увеличить скорость из-за того, что сборка мусора занимает больше времени, когда в памяти находится больше данных.

	States are added with a string identifier and an intialisation function.
	It is expect the init function, when called, will return a table with
	Render, Update, Enter and Exit methods.
	Состояния добавляются со строковым идентификатором и функцией инициализации.
	Ожидается, что функция инициализации при вызове вернет таблицу с методами Render, Update, Enter и Exit.

	gStateMachine = StateMachine {
			['MainMenu'] = function()
				return MainMenu()
			end,
			['InnerGame'] = function()
				return InnerGame()
			end,
			['GameOver'] = function()
				return GameOver()
			end,
	}
	gStateMachine:change("MainGame")

	Аргументы, переданные в функцию Change после имени состояния, будут перенаправлены в функцию Enter нового состояния.
	Идентификаторы состояний должны иметь теже имена, что и таблице состояний,
	если конечно нет веских причин не делать этого. Таким образом MainMenu состояние созается 
	['MainMenu'] ключом в таблице StateMashine. Это помогает использовать прямое соответствие.
]]

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end
