SPHERE_X = 175                          #Larghezza della sfera
SPHERE_Y = 175                          #Altezza della sfera
CENTRE_X = DEFAULTSCREENWIDTH/2         #Centro dello schermo (asse X)
CENTRE_Y = DEFAULTSCREENHEIGHT/2        #Centro dello schermo (asse Y)
X_MOVE = 22                             #Offset della sfera
ICON_X = 50                             #Larghezza delle icone principali
ICON_Y = 50                             #Altezza delle icone principali
BLOCK_X = 155							#Larghezza del blocco di sfondo
BLOCK_Y = 38							#Altezza del blocco di sfondo
IMG_NAME = ["men","messages","bag","user","options"]    #Array al nome delle Resource (immagini) delle icone (in ordine di apparizione)
ICON_POS = [[322,98],[379,85],[436,100],[477,142],[493,202],[477,257],[436,299],[379,314],[322,301]]     #Posizioni assolute delle icone principali

#Menu di inizializzazione (debug)
def createMenu(selected=3)
  menuTemp = MenuBlock.new(selected)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(-1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(-1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(-1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(-1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.debugMove(1)
  for i in 0..20
    Graphics.update
  end
  menuTemp.dispose
end

#Classe principale, gestisce il blocco intero del menù (esegui con "var = MenuBlock.new")
class MenuBlock
  def initialize(selected=3)
    @main = IconMenu.new(selected)      #Definisco le icone principali inviaibili (prima della sfera perché devono essere al livello inferiore)
    @sphere = SphereMenu.new            #Definisco la sfera
    @temp = Sprite.new
    @main.startVisibility               #Avvio l'animazione delle icone principali
  end
 
  def dispose
    @main.dispose
    @sphere.dispose
  end
  
  def debugMove(pos)                    #Metodo di debug per il movimento
    @main.moveOptions(pos)
  end
  
end
 
#Funzione che gestisce la sfera centrale
class SphereMenu
  attr_accessor :sphere
  
  def initialize                        #Creo la sfera in fade-in
    @sphere = Sprite.new
    @sphere.bitmap = Cache.picture("sphere")
    @sphere.x = CENTRE_X + X_MOVE - SPHERE_X/2
    @sphere.y = CENTRE_Y - SPHERE_Y/2
    @sphere.opacity = 0
   
    for i in 0..10
      Graphics.update
      @sphere.opacity += 25
    end
    Graphics.update
  end
 
  def dispose                           #Elimino la sfera in fade-out 
   for i in 0..10
      Graphics.update
      @sphere.opacity -= 25
   end
    @sphere.dispose
  end
end
 
class IconMenu
  attr_accessor :selectedOpt
  attr_accessor :iconOpt
  attr_accessor :primaryMenu
  
  def initialize(selectedOpt)
    @selectedOpt = selectedOpt
    @iconOpt =[]
    for i in 0..4
      @iconOpt[i] = IconOption.new(i,5-@selectedOpt+i)
      @iconOpt[i].setOpacity(0)
    end
	@primaryMenu = PrimaryMenu.new(@selectedOpt)
  end
 
  def startVisibility
    for i in 0..4
      @iconOpt[i].setOpacity(255)
    end
    initialMove
    @iconOpt[selectedOpt-1].setSelect(true)
  end
 
  def initialMove
    startPos = 5-@selectedOpt
    @iconX =[]
    @iconY =[]
	@primaryX =[]
	
    for i in 0..4
      @iconX[i] = ((ICON_POS[startPos+i][0] - CENTRE_X - X_MOVE)/(15))
      @iconY[i] = ((ICON_POS[startPos+i][1] - CENTRE_Y)/(15))
    end
	
	for i in 0..@primaryMenu.optNum-1
	  @primaryX[i] = (40*@primaryMenu.primaryOpt[i].pos) / 5
	end
   
    for i in 0..8
      for k in 0..4
        @iconOpt[k].setX(@iconOpt[k].getX + @iconX[k])
        @iconOpt[k].setY(@iconOpt[k].getY + @iconY[k])
      end
      Graphics.update
    end
	
	for i in 0..4
	  for k in 0..4
        @iconOpt[k].setX(@iconOpt[k].getX + @iconX[k])
        @iconOpt[k].setY(@iconOpt[k].getY + @iconY[k])
      end
	  
	  for k in 0..@primaryMenu.optNum-1
		@primaryMenu.primaryOpt[k].setOpacity((i+1)*51)
		@primaryMenu.primaryOpt[k].setY(@primaryMenu.primaryOpt[k].y + @primaryX[k] * 40)
	  end
      Graphics.update
	end
	  
    for i in 0..4
      @iconOpt[i].setX(ICON_POS[@iconOpt[i].getPos][0] - ICON_X/2)
      @iconOpt[i].setY(ICON_POS[@iconOpt[i].getPos][1] - ICON_Y/2)
    end
	for k in 0..@primaryMenu.optNum-1
	  @primaryMenu.primaryOpt[k].setOpacity((i+1)*51)
	  @primaryMenu.primaryOpt[k].setY(CENTRE_Y-BLOCK_Y/2 + @primaryMenu.primaryOpt[k].pos*40)
	end
    Graphics.update
  end

  def moveOptions(pos)
    for i in 0..4
      @iconX[i] = (ICON_POS[@iconOpt[i].getPos-pos][0] - ICON_POS[@iconOpt[i].getPos][0])/5
      @iconY[i] = (ICON_POS[@iconOpt[i].getPos-pos][1] - ICON_POS[@iconOpt[i].getPos][1])/5
    end
    
    for i in 0..3
      for i in 0..4
        @iconOpt[i].setX(@iconOpt[i].getX + @iconX[i])
        @iconOpt[i].setY(@iconOpt[i].getY + @iconY[i])
      end
      Graphics.update
    end
    
    @iconOpt[@selectedOpt-1].setSelect(false)
    @selectedOpt += pos
    @iconOpt[@selectedOpt-1].setSelect(true)
    
    for i in 0..4
      @iconOpt[i].setPos(@iconOpt[i].getPos-pos)
      @iconOpt[i].setX(ICON_POS[@iconOpt[i].getPos][0] - ICON_X/2)
      @iconOpt[i].setY(ICON_POS[@iconOpt[i].getPos][1] - ICON_Y/2)
    end
    Graphics.update
    
=begin
    case pos
    when 0
      @icon.x = ICON_POS[0][0]-ICON_X/2
      @icon.y = ICON_POS[0][1]-ICON_Y/2
    when 1
      @icon.x = ICON_POS[1][0]-ICON_X/2
      @icon.y = ICON_POS[1][1]-ICON_Y/2
    when 2
      @icon.x = ICON_POS[2][0]-ICON_X/2
      @icon.y = ICON_POS[2][1]-ICON_Y/2
    when 3
      @icon.x = ICON_POS[3][0]-ICON_X/2
      @icon.y = ICON_POS[3][1]-ICON_Y/2
    when 4
      @icon.x = ICON_POS[4][0]-ICON_X/2
      @icon.y = ICON_POS[4][1]-ICON_Y/2
    when 5
      @icon.x = ICON_POS[5][0]-ICON_X/2
      @icon.y = ICON_POS[5][1]-ICON_Y/2
    when 6
      @icon.x = ICON_POS[6][0]-ICON_X/2
      @icon.y = ICON_POS[6][1]-ICON_Y/2
    when 7
      @icon.x = ICON_POS[7][0]-ICON_X/2
      @icon.y = ICON_POS[7][1]-ICON_Y/2
    end
=end
  end
 
  def dispose
    @incX =[]
    @incY =[]
    for i in 0..4
      @incX[i] = ((ICON_POS[@iconOpt[i].getPos][0] - CENTRE_X - X_MOVE)/(15))
      @incY[i] = ((ICON_POS[@iconOpt[i].getPos][1] - CENTRE_Y)/(15))
    end
   
    for i in 0..14
      for k in 0..4
        @iconOpt[k].setX(@iconOpt[k].getX - @incX[k])
        @iconOpt[k].setY(@iconOpt[k].getY - @incY[k])
      end
      Graphics.update
    end
    for i in 0..4
      @iconOpt[i].setX(CENTRE_X - ICON_X/2)
      @iconOpt[i].setY(CENTRE_Y - ICON_Y/2)
    end
    Graphics.update
    for i in 0..4
      @iconOpt[i].dispose
    end
  end
 
end
 
class IconOption
  attr_accessor :res
  attr_accessor :pos
 
  def initialize(res,pos)
    @res = res
    @pos = pos
   
    @icon = Sprite.new
    @icon.bitmap = Cache.picture(IMG_NAME[@res])
    @selected = false
 
    @icon.x = CENTRE_X + X_MOVE - ICON_X/2
    @icon.y = CENTRE_Y - ICON_Y/2
  end
 
  def setSelect(status)
    @icon.bitmap = Cache.picture(IMG_NAME[@res]+"_on") if status == true
    @icon.bitmap = Cache.picture(IMG_NAME[@res]) if status == false
  end
 
  def getPos
    return pos
  end
  
  def setPos(pos)
    @pos = pos
  end
 
  def getOpacity
    return @icon.opacity
  end
 
  def setOpacity(opacity)
    @icon.opacity = opacity
  end
 
  def getX
    return @icon.x
  end
 
  def setX(val)
    @icon.x = val
  end
 
  def getY
    return @icon.y
  end
 
  def setY(val)
    @icon.y = val
  end
 
  def dispose
    @icon.dispose
  end
end
 
class PrimaryMenu
  attr_accessor :res
  attr_accessor :primaryOpt
  attr_accessor :optNum
  
  def initialize(res)
    @res = res-1
	
    @primaryOpt =[]
	
    case @res
    when 0
      @primaryOpt[0] = PrimaryOption.new(0,"Pokémon","items")
      @primaryOpt[1] = PrimaryOption.new(1,"PokéDex","items")
    when 1
      @primaryOpt[0] = PrimaryOption.new(-1,"Mail","mail")
      @primaryOpt[1] = PrimaryOption.new(0,"Messaggi di Sistema","items")
      @primaryOpt[2] = PrimaryOption.new(1,"PokéGear","items")
    when 2
      @primaryOpt[0] = PrimaryOption.new(-3,"Strumenti","items")
      @primaryOpt[1] = PrimaryOption.new(-2,"Rimedi","plus")
      @primaryOpt[2] = PrimaryOption.new(-1,"Poké Balls","pokeball")
      @primaryOpt[3] = PrimaryOption.new(0,"MT & MN","blades")
      @primaryOpt[4] = PrimaryOption.new(1,"bacche","berry")
      @primaryOpt[5] = PrimaryOption.new(2,"Potenziamenti","parrying")
      @primaryOpt[6] = PrimaryOption.new(3,"Strumenti base","base_items")
    when 3
      @primaryOpt[0] = PrimaryOption.new(-1,"Statistiche","items")
      @primaryOpt[1] = PrimaryOption.new(0,"Scheda allenatore","items")
      @primaryOpt[2] = PrimaryOption.new(1,"Equipaggiamento","items")
    when 4
      @primaryOpt[0] = PrimaryOption.new(-1,"Informazioni","items")
      @primaryOpt[1] = PrimaryOption.new(0,"Salva Partita","items")
      @primaryOpt[2] = PrimaryOption.new(1,"Impostazioni","items")
    end
    @optNum = @primaryOpt.length
  end
  
  def move(num)
    if @optNum+num>=0 && @optNum+num<@primaryOption.size
      @primaryOpt[@optNum].setSelect(false)
      @optNum += num
      @primaryOpt[@optNum].setSelect(true)
      @primaryOpt.each do |opt|
        opt.pos += num
      end
      
      for i in 0..5
        @primaryOpt.each do |opt|
          opt.setY(opt.getY+(40/5)*(-num))
          if opt.pos = @optNum
            #TODO
          end
        end
      end
      return true
    else
      return false
    end
  end
end
 
class PrimaryOption
	attr_accessor :pos
	attr_accessor :nameStr
	attr_accessor :icon
	attr_accessor :x
	attr_accessor :y
	attr_accessor :opacity
	attr_accessor :arrow
	attr_accessor :bg
	attr_accessor :icon
	attr_accessor :name
	attr_accessor :arrowPos
	
  def initialize(pos,nameStr,icon)
    @pos = pos
    @nameStr = nameStr
    @icon = icon
    
    @arrow = Sprite.new
    @bg = Sprite.new
    @icon = Sprite.new
    @name = Sprite.new
  
    if @pos != 0
      @arrow.bitmap = Cache.picture("primary_arrow")
      @bg.bitmap = Cache.picture("block")
      @icon.bitmap = Cache.picture(@icon.to_s)
    else
      @arrow.bitmap = Cache.picture("primary_arrow_on")
      @bg.bitmap = Cache.picture("block_on")
      @icon.bitmap = Cache.picture(@icon.to_s + "_on")
    end  
  
    @name.bitmap = Bitmap.new(BLOCK_X-40,BLOCK_Y)
    @name.bitmap.font = Font.new("SAO UI", 24)
    @name.bitmap.draw_text(0,0,BLOCK_X-40,BLOCK_Y,@nameStr)
  
    @x = 505
    @y = CENTRE_Y - BLOCK_Y/2
    
    @arrowPos = 0
    @arrow.x = @x + 35
    @bg.x = @x + 35
    @icon.x = @x + 40
    @name.x = @x + 75
    
    @arrow.y = @y
    @bg.y = @y
    @icon.y = @y
    @name.y = @y
    
    @arrow.opacity = 0
    @bg.opacity = 0
    @icon.opacity = 0
    @name.opacity = 0
  end

  def dispose
    @arrow.dispose
    @bg.dispose
    @icon.dispose
    @name.dispose
  end
  
  def setX(x)
    @x = x
    @arrow.x = @x + 35
    @bg.x = @x + 35
    @icon.x = @x + 40
    @name.x = @x + 75
  end
  
  def setY(y)
	@y = y
	@arrow.y = @y
    @bg.y = @y
	@icon.y = @y
	@name.y = @y
  end
  
  def setOpacity(opacity)
	@opacity = opacity
	@arrow.opacity = @opacity
	@bg.opacity = @opacity
	@icon.opacity = @opacity
	@name.opacity = @opacity
  end
  
  def moveArrow(pos)
    @arrowPos = pos
	@arrow.x = @x + 35 - @arrowPos
  end
  
  def setSelect(select)
    if select == true
      @arrow.bitmap = Cache.picture("primary_arrow_on")
      @bg.bitmap = Cache.picture("block_on")
      @icon.bitmap = Cache.picture(@icon.to_s + "_on")
    else
      @arrow.bitmap = Cache.picture("primary_arrow")
      @bg.bitmap = Cache.picture("block")
      @icon.bitmap = Cache.picture(@icon.to_s)
    end
  end
end
 
class SecondaryMenu
  def initialize
    @arrow = Sprite.new
    @option =[]
  end
end
 
class SecondaryOption
  def initialize
    @bg = Sprite.new
    @icon = Sprite.new
    @name = Sprite.new
  end
end
 
class PokeMenu
  def initialize
    @bg = Sprite.new
    @name = Sprite.new
    @dex = Sprite.new
    @pokemon =[]
  end
end
 
class PokeOption
  def initialize
    @name = Sprite.new
    @ball =[Sprite.new,Sprite.new]
    @hpBar = hpBar.new
    @hpMax = Sprite.new
    @hpNow = Sprite.new
    @status = Sprite.new
    @sex = Sprite.new
  end
end
 
class HpBar
  def initialize
    @border = Sprite.new
    @bar = Sprite.new
  end
end