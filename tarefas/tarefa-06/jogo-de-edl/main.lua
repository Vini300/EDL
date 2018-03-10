texto = ""
-- Nome: variável "texto"
-- Propriedade: endereço
-- Binding time: compilação
-- Explicação: A variável "texto" é uma variável global do programa, e portanto possui seu endereço definido
-- durante a compilação do código-fonte, já que o Lua trata as variáveis globais como uma tabela que é criada
-- em tempo de compilação, e carregada junto ao programa para guardar as variáveis globais. (Nota: Peço
-- desculpas pela edição do programa depois da entrega do trabalho, mas queria alterá-lo para garantir que
-- a variável texto fosse criada como uma variável global fora de qualquer função)

function getCartesiano(xv,yv)
	local cartesiano = {}
	-- Nome: variável "cartesiano"
	-- Propriedade: endereço
	-- Binding time: execução
	-- Explicação: A variável "cartesiano" é uma tabela, e portanto seu endereço de memória é criado na Heap,
	-- por necessitar de variação no tamanho da tabela durante a execução e, já que toda variável criada na
	-- Heap é criada em tempo de execução, o espaço de memória de "cartesiano" somente pode ser determinado
	-- em tempo de execução.
	cartesiano.x = xv
	cartesiano.y = yv
	return cartesiano
end
-- Nome: função "getCartesiano()"
-- Propriedade: implementação
-- Binding time: compilação
-- Explicação: A função "getCartesiano()" é um nome estático usado por todo o código, e criado fora de
-- qualquer função. Portanto, ela foi criada em tempo de compilação, já que sua implementação é atribuída
-- ao nome "getCartesiano()" quando o programa é compilado.

function getAnimacao(atlas, width, height, duration)
	local animacao = {}
	animacao.spriteSheet = atlas;
	animacao.sprites = {}
	for y = 0, atlas.getHeight(atlas) - height, height do
		for x = 0, atlas.getWidth(atlas) - width, width do
			table.insert(animacao.sprites, love.graphics.newQuad(x, y, width, height, atlas.getDimensions(atlas)))
		end
	end
	animacao.duration = duration
	animacao.currentTime = 0
	return animacao
end

function endGame(congratulations)
	congratulations = congratulations or false
	if (congratulations) then
		displayText = true
		texto = "Completo!"
	else
		displayText = true
		texto = "Tente de Novo!"
	end
	gameOver = true
	timer = 0
	extras.limpar()
end

function acharRotacao(x,y)
	if x == 1 then
		return math.pi/2
	elseif x == -1 then
		return 3 * math.pi/2
	elseif y == 1 then
		return math.pi
	else
		return 0
	end
end
-- Nome: símbolo "*"
-- Propriedade: semântica
-- Binding time: design
-- Explicação: O símbolo "*", significando multiplicação entre dois valores, é um nome cuja semântica (a 
-- multiplicação em si) é atribuída a ela no tempo de design da linguagem, pois todo programa feito na
-- linguagem que utiliza o símbolo "*" possui a mesma semântica para "*", que é a semântica definida pelos
-- criadores da linguagem Lua durante o design da mesma. 

-- Nome: variável "math.pi"
-- Propriedade: valor
-- Binding time: design
-- Explicação: A variável "math.pi", pertencente à biblioteca padrão de matemática do Lua, é tratada como
-- uma tabela externa ao programa, com seus valores sendo definidos no tempo de design da biblioteca (no caso,
-- tempo de design da linguagem, por ser uma biblioteca padrão).

function getJogador(posx,posy)
	local jogador = {}
	jogador.pos = getCartesiano(posx,posy)
	jogador.vel = getCartesiano(0,0)
	jogador.dir = getCartesiano(1,0)
	jogador.selDir = true
	jogador.selecionarDir =
	function (dirx,diry)
		jogador.dir.x = dirx
		jogador.dir.y = diry
	end
	jogador.mover = 
	function (dt)
		if (((jogador.pos.x + jogador.vel.x * dt) >= 800) or ((jogador.pos.x + jogador.vel.x * dt) <= 0)) then --colisão com fora do mapa (eixo x)
			endGame()
		elseif (((jogador.pos.y + jogador.vel.y * dt) >= 600) or ((jogador.pos.y + jogador.vel.y *dt) <= 0)) then --colisão com fora do mapa (eixo y)
			endGame()
		end
		for i = 1, numObst do
			if(((jogador.pos.x + jogador.vel.x * dt) <= obst[i].pos.x + (obst[i].tam.x)) and ((jogador.pos.x + jogador.vel.x * dt) + 50 >= obst[i].pos.x)) then --colisão com objeto (eixo x)
				if(((jogador.pos.y + jogador.vel.y * dt) <= obst[i].pos.y + (obst[i].tam.y)) and ((jogador.pos.y + jogador.vel.y * dt) + 50 >= obst[i].pos.y)) then --colisão com objeto (eixo y)
					endGame()
				end
			end
		end
		if (not gameOver and not selDir and not congratulations) then --mover o jogador
			jogador.pos.x = jogador.pos.x + jogador.vel.x
			jogador.pos.y = jogador.pos.y + jogador.vel.y
		end
		for i = 1, numPick do
			if((jogador.pos.x == pick[i].pos.x) and (jogador.pos.y == pick[i].pos.y)) then --checar se coletou um pickup
				if (pick[i].noMapa) then
					jogador.selDir = true
					jogador.selecionarDir()
					pick[i].pegou()
				end
			end
		end
		for i = 1, numExtra*2 do
			if (extras[i]) then
				if((jogador.pos.x == extras[i].pos.x) and (jogador.pos.y == extras[i].pos.y)) then --checar se coletou um extra
					extras[i].pegou()
				end
			end
		end
		if ((jogador.pos.x == goal.pos.x) and (jogador.pos.y == goal.pos.y)) then --checar se ganhou o jogo
			if (totalPick == 0) then
				endGame(true)
			else
				endGame()
			end
		end
	end
	jogador.disparar =
	function ()
		jogador.vel.x = 10*jogador.dir.x
		jogador.vel.y = 10*jogador.dir.y
		jogador.selDir = false
	end
	return jogador

	-- tarefa-06
	-- A variável "jogador" contém um dicionário.
end

function getPickup(posx,posy)
	local pickup = {}
	pickup.pos = getCartesiano(posx,posy)
	pickup.noMapa = true
	pickup.pegou = --apaga o pickup e para o jogoador 
	function ()
		pickup.noMapa = false
		totalPick = totalPick - 1
		sinalCriacao = true --editado para tarefa 05
	end
	return pickup
end

function getGoal(posx,posy)
	local goal = {}
	goal.pos = getCartesiano(posx,posy)
	return goal
end

function getObstaculo(posx,posy,tamx,tamy,maxposx,maxposy,minposx,minposy,velmult)
	local obstaculo = {}
	obstaculo.pos = getCartesiano(posx,posy)
	obstaculo.tam = getCartesiano(tamx,tamy)
	obstaculo.maxpos = getCartesiano(maxposx,maxposy)
	obstaculo.minpos = getCartesiano(minposx,minposy)
	obstaculo.vel = getCartesiano((maxposx-minposx)/5 * velmult,(maxposy-minposy)/5 * velmult)
	obstaculo.flip = --gira a direção para qual o obstáculo anda
	function ()
		obstaculo.vel.x = -obstaculo.vel.x
		obstaculo.vel.y = -obstaculo.vel.y
	end
	obstaculo.mover = 
	function (dt)
		if (not (obstaculo.vel.x == 0)) then
			if(((obstaculo.pos.x + obstaculo.vel.x * dt) >= obstaculo.maxpos.x) or ((obstaculo.pos.x + obstaculo.vel.x * dt) <= obstaculo.minpos.x)) then --colisão com o limite de espaço (eixo x)
				obstaculo.flip()
			end
		elseif (not (obstaculo.vel.y == 0)) then
			if(((obstaculo.pos.y + obstaculo.vel.y * dt) >= obstaculo.maxpos.y) or ((obstaculo.pos.y + obstaculo.vel.y * dt) <= obstaculo.minpos.y)) then --colisão com o limite de espaço (eixo y)
				obstaculo.flip()
			end
		end
		obstaculo.pos.x = obstaculo.pos.x + obstaculo.vel.x * dt --mover o obstáculo
		obstaculo.pos.y = obstaculo.pos.y + obstaculo.vel.y * dt
	end
	return obstaculo
end

--Bloco de edições para tarefa 07 começa aqui

function getMarcadorExtra(x,y)
	local marcador = {}
	marcador.x = x
	marcador.y = y
	marcador.possui = false
	return marcador
end

function getObjExtra(x,y,id)
	local objExtra = {}
	objExtra.x = x
	objExtra.y = y
	objExtra.id = id
	return objExtra
end

function acharPossivelExtra()
	achou = false
	tentativa = -1
	numTent = 0
	while not achou do
		numTent = numTent + 1
		tentativa = love.math.random(numExtra*2)
		if lugarExtras[tentativa].possui == false then
			if pick[math.ceil(tentativa/2)].noMapa then
				print(pick[math.ceil(tentativa/2)].noMapa)
				achou = true
			end
		end
		if numTent > numExtra*2 then
			break
		end
	end
	if achou then
		possivel = getObjExtra(lugarExtras[tentativa].x,lugarExtras[tentativa].y,tentativa)
		print(math.ceil(tentativa/2))
		lugarExtras[tentativa].possui = true
		return possivel
	end
	return nil
end

function acharPossivelTipoExtra()
	tipo = love.math.random(4)
	if tipo == 4 then
		return 200
	end
	return 50
end

function getVetExtra()
	local vetExtra = {}
	vetExtra.currmax = 0
	vetExtra.adicionar =
		function()
			num = -1
			for i = 1, vetExtra.currmax do
				if vetExtra[i] == nil then
					num = i
					break
				end
			end
			if num == -1 then
				if vetExtra.currmax + 1 >= numExtra then return end
				vetExtra.currmax = vetExtra.currmax + 1
				num = vetExtra.currmax
			end
			atual = acharPossivelExtra()
			if atual then
				vetExtra[num] = getExtra(atual.x,atual.y,acharPossivelTipoExtra(),num,atual.id)
			end
		end
	vetExtra.deletar =
		function(num)
			if num == vetExtra.currmax then
				vetExtra.currmax = vetExtra.currmax - 1
			end
			if vetExtra[num] then
				if (lugarExtras[vetExtra[num].id]) then
					lugarExtras[vetExtra[num].id].possui = false
					vetExtra[num] = nil
				end
			end
		end
	vetExtra.limpar =
		function()
			for i = 1,vetExtra.currmax do
				vetExtra.deletar(i)
			end
			vetExtra.currmax = 0
		end
	return vetExtra
end

function getExtra(posx,posy,tipoPoint,num,id)
	local extra = {}
	extra.pos = getCartesiano(posx,posy)
	extra.tipo = tipoPoint
	extra.num = num
	extra.id = id
	extra.pegou =
		function()
			extras.deletar(extra.num)
			pontos = pontos + extra.tipo
		end
	return extra
end

--Bloco de edições para tarefa 07 termina aqui

function menu()
	texto = [[Bem vindo ao Trabalho de EDL.

Se a nave estiver parada, mude sua direção usando as setas.

Ainda com a nave parada, aperte BARRA DE ESPAÇO para voar na direção escolhida.

A tecla BARRA DE ESPAÇO também sairá desta introdução.

Quando coletar um MOVEDOR (círculo azul), poderá alterar sua direção.

Colete todos os MOVEDORES antes de chegar na SAÍDA (círculo verde) para vencer.

Porém, se tocar em um OBSTÁCULO (retângulo vermelho), perderá o jogo.

Existem 4 variações da fase. Perca ou complete para mudar a variação atual.

Divirta-se. Aluno: Vinícius Passos de Oliveira Soares.]]
	menu = true
end

function carregarNivel1() 
	j1 = getJogador(150,250)
	numPick = love.math.random(4)
	totalPick = numPick
	numObst = numPick
	--Bloco de edições para tarefa 07 começa aqui
	sinalCriacao = true
	numExtra = numPick
	pontos = 0
	lugarExtras = {}
	extras = getVetExtra()
	--Bloco de edições para tarefa 07 termina aqui
	pick = {}
	obst = {}
	posicoesPicks = {{600, 250}, {600, 50}, {150, 50}, {150, 500}}
	pick[1] = getPickup(posicoesPicks[1][1], posicoesPicks[1][2])
	pick[2] = getPickup(posicoesPicks[2][1], posicoesPicks[2][2])
	pick[3] = getPickup(posicoesPicks[3][1], posicoesPicks[3][2])
	pick[4] = getPickup(posicoesPicks[4][1], posicoesPicks[4][2])
	posicoesObst = {{400, 250}, {600, 150}, {150, 150}, {150, 350}}
	obst[1] = getObstaculo(posicoesObst[1][1], posicoesObst[1][2],20,100,200,450,200,100,2)
	obst[2] = getObstaculo(posicoesObst[2][1], posicoesObst[2][2],20,60,700,150,500,150,1)
	obst[3] = getObstaculo(posicoesObst[3][1], posicoesObst[3][2],80,40,250,200,50,200,1.3)
	obst[4] = getObstaculo(posicoesObst[4][1], posicoesObst[4][2],80,40,250,200,50,200,-1.3)
	--Bloco de edições para tarefa 07 começa aqui
	posicoesExtra = {{600, 320}, {600, 420}, {600, 150}, {450, 50}, {300, 50}, {150, 150}, {150, 370}, {370, 500}}
	lugarExtras[1] = getMarcadorExtra(posicoesExtra[1][1], posicoesExtra[1][2])
	lugarExtras[2] = getMarcadorExtra(posicoesExtra[2][1], posicoesExtra[2][2])
	lugarExtras[3] = getMarcadorExtra(posicoesExtra[3][1], posicoesExtra[3][2])
	lugarExtras[4] = getMarcadorExtra(posicoesExtra[4][1], posicoesExtra[4][2])
	lugarExtras[5] = getMarcadorExtra(posicoesExtra[5][1], posicoesExtra[5][2])
	lugarExtras[6] = getMarcadorExtra(posicoesExtra[6][1], posicoesExtra[6][2])
	lugarExtras[7] = getMarcadorExtra(posicoesExtra[7][1], posicoesExtra[7][2])
	lugarExtras[8] = getMarcadorExtra(posicoesExtra[8][1], posicoesExtra[8][2])
	--Bloco de edições para tarefa 07 termina aqui
	goal = getGoal(600,500) --gerar o objetivo
end

function reiniciar()
	menu = false
	gameOver = false
	direcao = "right"
	displayText = false
	texto = ""
	timer = 0
	nave = love.graphics.newImage("player.png")
	movedor = love.graphics.newImage("mover.png")
	extra50 = love.graphics.newImage("fuel50.png")
	extra200 = love.graphics.newImage("fuel200.png")
	fim = getAnimacao(love.graphics.newImage("goalanim.png"),50,50,0.5)
	fundo = love.graphics.newImage("fundo.png")
	carregarNivel1()
end

function love.load()
	menu()
end

function love.update(dt)
	if (not menu) then
		if (gameOver) then
			timer = timer + dt
			if (timer >= 3) then --esperar 3 segundos antes de reiniciar o jogo
				reiniciar()
			end
		else
			for i = 1, numObst do --mover os obstaculos
				obst[i].mover(dt)
			end
			if (not j1.selDir) then
				j1.mover(dt) --mover o jogador
			else
				dirx = 0
				diry = 0
				if (direcao == "right") then
					dirx = 1
					diry = 0
				elseif (direcao == "left") then
					dirx = -1
					diry = 0
				elseif (direcao == "up") then
					dirx = 0
					diry = -1
				elseif (direcao == "down") then
					dirx = 0
					diry = 1
				end
				j1.selecionarDir(dirx,diry)
			end
			if sinalCriacao then
				numCriacao = love.math.random(math.floor(numExtra/2))
				for i = 1, numCriacao do
					extras.adicionar()
				end
				sinalCriacao = false
			end
		end
		fim.currentTime = fim.currentTime + dt
		if (fim.currentTime >= fim.duration) then
			fim.currentTime = fim.currentTime - fim.duration
		end
	end
end

function love.draw()
	if (not menu) then
		love.graphics.setColor(255,255,255)
		local spriteNum = math.floor(fim.currentTime/fim.duration * #fim.sprites) + 1
		love.graphics.draw(fundo)
		if (not gameOver) then
			for i = 1, numExtra*2 do
				if extras[i] then
					if extras[i].tipo == 50 then
						love.graphics.draw(extra50,extras[i].pos.x,extras[i].pos.y,0,1,1,0,0)
					else
						love.graphics.draw(extra200,extras[i].pos.x,extras[i].pos.y,0,1,1,0,0)
					end
				end
			end
			for i = 1, numPick do
				if (pick[i].noMapa) then
					love.graphics.draw(movedor,pick[i].pos.x,pick[i].pos.y,0,1,1,0,0) --desenhar os pickups
				end
			end
			love.graphics.draw(fim.spriteSheet,fim.sprites[spriteNum],goal.pos.x,goal.pos.y,0,1,1,0,0) --desenha o objetivo
			love.graphics.draw(nave,j1.pos.x+25,j1.pos.y+25,acharRotacao(j1.dir.x, j1.dir.y),1,1,25,25) --desenhar o jogador
			for i = 1, numObst do
				love.graphics.setColor(255,0,0)
				love.graphics.rectangle("fill",obst[i].pos.x,obst[i].pos.y,obst[i].tam.x,obst[i].tam.y) --desenhar os obstaculos
			end
			love.graphics.setColor(255,255,255)
			love.graphics.printf("Pontos Extras: " .. pontos,10,10,1000,"left")
		else
			love.graphics.setColor(255,255,255)
			love.graphics.printf(texto,350,290,100,"center")
		end
	else
		love.graphics.setColor(255,255,255)
		love.graphics.printf(texto,125,175,550,"center")
	end
end

function love.keypressed(key)
	if (not menu) then
		if (j1.selDir) then
			if (key == "down") then
				direcao = "down"
			elseif (key == "up") then
				direcao = "up"
			elseif (key == "left") then
				direcao = "left"
			elseif (key == "right") then
				direcao = "right"
			end
			if (key == "space") then
				j1.disparar()
			end
		end
	end
	if (menu) then
		if (key == "space") then
			reiniciar()
		end
	end
	if (key == "escape" and not gameOver) then
		love.event.quit()
	end
end
-- Nome: variável "direcao"
-- Propriedade: valor
-- Binding time: execução
-- Explicação: Como "direcao" é uma variável cujo valor é definido pela entrada do usuário, seu valor
-- somente pode ser definido quando o usuário interage com o programa em questão, ou seja, seu valor
-- somente pode ser atribuído ao nome durante a execução do programa.