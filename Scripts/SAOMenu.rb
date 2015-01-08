SPHERE_X = 175                          #Larghezza della sfera
SPHERE_Y = 175                          #Altezza della sfera
CENTRE_X = DEFAULTSCREENWIDTH/2         #Centro dello schermo (asse X)
CENTRE_Y = DEFAULTSCREENHEIGHT/2        #Centro dello schermo (asse Y)
X_MOVE = 22                             #Offset della sfera
ICON_X = 50                             #Larghezza delle icone principali
ICON_Y = 50                             #Altezza delle icone principali
IMG_NAME = ["men","messages","bag","user","options"]    #Array al nome delle Resource (immagini) delle icone (in ordine di apparizione)
ICON_POS = [[322,98],[379,85],[436,100],[477,142],[493,202],[477,257],[436,299],[379,314],[322,301]]     #Posizioni assolute delle icone principali

#Classe principale, gestisce il blocco intero del menù (esegui con "var = MenuBlock.new")
class MenuBlock
  def initialize(selected=3)
    @main = MainMenu.new(selected)      #Definisco le icone principali inviaibili (prima della sfera perché devono essere al livello inferiore)
    @sphere = SphereMenu.new            #Definisco la sfera
    @temp = Sprite.new
    @main.startVisibility               #Avvio l'animazione delle icone principali
  end
 
  def dispose
    @main.dispose
    @sphere.dispose
  end
end
 
#Funzione che gestisce la sfera centrale
class SphereMenu
  def initialize                        #Creo la sfera in fade-in
    @sphere = Sprite.new
    @sphere.bitmap = Cache.picture("sphere")
    @sphere.x = CENTRE_X + X_MOVE - SPHERE_X/2
    @sphere.y = CENTRE_Y - SPHERE_Y/2
    @sphere.opacity = 0
   
    for i in 0..255/25
      Graphics.update
      @sphere.opacity += 25
    end
    Graphics.update
  end
 
  def dispose                           #Elimino la sfera in fade-out 
   for i in 0..255/25
      Graphics.update
      @sphere.opacity -= 25
   end
    @sphere.dispose
  end
end
 
class MainMenu
  attr_accessor :selectedOpt
  
  def initialize(selectedOpt)
    @selectedOpt = selectedOpt
    @option =[]
    for i in 0..4
      @option[i] = MainOption.new(i,5-@selectedOpt+i)
      @option[i].setOpacity(0)
    end
  end
 
  def startVisibility
    for i in 0..4
      @option[i].setOpacity(255)
    end
    initialMove
    @option[selectedOpt-1].setSelect(true)
  end
 
  def initialMove
    startPos = 5-@selectedOpt
    @incX =[]
    @incY =[]
    for i in 0..4
      @incX[i] = ((ICON_POS[startPos+i][0] - CENTRE_X - X_MOVE)/(15))
      @incY[i] = ((ICON_POS[startPos+i][1] - CENTRE_Y)/(15))
    end
   
    for i in 0..14
      for k in 0..4
        @option[k].setX(@option[k].getX + @incX[k])
        @option[k].setY(@option[k].getY + @incY[k])
      end
      Graphics.update
    end
    for i in 0..4
      @option[i].setX(ICON_POS[@option[i].getPos][0] - ICON_X/2)
      @option[i].setY(ICON_POS[@option[i].getPos][1] - ICON_Y/2)
    end
    Graphics.update
  end
   
  def moveOptions(pos)
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
  end
 
  def dispose
    @incX =[]
    @incY =[]
    for i in 0..4
      @incX[i] = ((ICON_POS[@option[i].getPos][0] - CENTRE_X - X_MOVE)/(15))
      @incY[i] = ((ICON_POS[@option[i].getPos][1] - CENTRE_Y)/(15))
    end
   
    for i in 0..14
      for k in 0..4
        @option[k].setX(@option[k].getX - @incX[k])
        @option[k].setY(@option[k].getY - @incY[k])
      end
      Graphics.update
    end
    for i in 0..4
      @option[i].setX(CENTRE_X - ICON_X/2)
      @option[i].setY(CENTRE_Y - ICON_Y/2)
    end
    Graphics.update
    for i in 0..4
      @option[i].dispose
    end
  end
 
end
 
class MainOption
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
 
class SecondaryMenu
  def initialize
    @option =[]
  end
end
 
class SecondaryOption
  def initialize
    @bg = Sprite.new
    @icon = Sprite.new
    @name = Sprite.new
    @arrow = Sprite.new
  end
end
 
class ChooseMenu
  def initialize
    @arrow = Sprite.new
    @option =[]
  end
end
 
class ChooseOption
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