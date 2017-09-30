function love.load() 
    texto = "Instalado."
    texto2 = "Aluno: Vinicius Soares."
    caixaCor = {255,255,255}
    tamx = 200
    tamy = 100
    posx = 400-tamx/2
    posy = 300-tamy/2
    vel = 100
end

function love.update(dt)
    if (moveup) then
        if (moveright) then
            posx = posx + vel*dt/2
            posy = posy - vel*dt/2
        elseif (moveleft) then
            posx = posx - vel*dt/2
            posy = posy - vel*dt/2
        else
            posy = posy - vel*dt
        end
    elseif (movedown) then
        if (moveright) then
            posx = posx + vel*dt/2
            posy = posy + vel*dt/2
        elseif (moveleft) then
            posx = posx - vel*dt/2
            posy = posy + vel*dt/2
        else
            posy = posy + vel*dt
        end
    elseif (moveright) then
        posx = posx + vel*dt
    elseif (moveleft) then
        posx = posx - vel*dt
    end
end

function love.draw()
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setColor(caixaCor[1],caixaCor[2],caixaCor[3])
    love.graphics.rectangle("fill", posx, posy, tamx, tamy)
    love.graphics.setColor(0,0,0)
    love.graphics.print(texto, posx+(tamx/2)-30, posy+(tamy/2)-28)
    love.graphics.print(texto2, posx+(tamx/2)-65, posy+(tamy/2)+18)
end

function love.keyreleased(key)
    if (key == 'up') then
        moveup = false
    end
    if (key == 'down') then
        movedown = false
    end
    if (key == 'left') then
        moveleft = false
    end
    if (key == 'right') then
        moveright = false
    end
end

function love.keypressed(key)
    if (key == 'up') then
        moveup = true
    end
    if (key == 'down') then
        movedown = true
    end
    if (key == 'left') then
        moveleft = true
    end
    if (key == 'right') then
        moveright = true
    end
    if (key == 'q') then
        caixaCor[1] = 255
        caixaCor[2] = 0
        caixaCor[3] = 0
    end
    if (key == 'w') then
        caixaCor[1] = 0
        caixaCor[2] = 255
        caixaCor[3] = 0
    end
    if (key == 'e') then
        caixaCor[1] = 0
        caixaCor[2] = 0
        caixaCor[3] = 255
    end
end