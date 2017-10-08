function getCartesiano(xv,yv)
	local cartesiano = {}
	cartesiano.x = xv
	cartesiano.y = yv
	return cartesiano
end

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
			if(((jogador.pos.x + jogador.vel.x * dt) <= obst[i].pos.x + (obst[i].tam.x/2 - 15)) and ((jogador.pos.x + jogador.vel.x * dt) >= obst[i].pos.x - (obst[i].tam.x/2 + 15))) then --colisão com objeto (eixo x)
				if(((jogador.pos.y + jogador.vel.y * dt) <= obst[i].pos.y + (obst[i].tam.y/2 + 15)) and ((jogador.pos.y + jogador.vel.y * dt) >= obst[i].pos.y - (obst[i].tam.y/2 + 15))) then --colisão com objeto (eixo y)
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
end

function getPickup(posx,posy)
	local pickup = {}
	pickup.pos = getCartesiano(posx,posy)
	pickup.noMapa = true
	pickup.pegou = --apaga o pickup e para o jogoador 
	function ()
		pickup.noMapa = false
		totalPick = totalPick - 1
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
	pick = {}
	obst = {}
	pick[1] = getPickup(600,250)
	pick[2] = getPickup(600,50)
	pick[3] = getPickup(150,50)
	pick[4] = getPickup(150,500)
	obst[1] = getObstaculo(400,250,20,100,200,450,200,100,2)
	obst[2] = getObstaculo(600,150,20,60,700,150,500,150,1)
	obst[3] = getObstaculo(150,150,80,40,250,200,50,200,1.3)
	obst[4] = getObstaculo(150,350,80,40,250,200,50,200,-1.3)
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