main = ($scope) ->
  $scope.backgrounds =[
    #{ name: \...上傳, link: \upload }
    { name: \清新, link: \hill.jpg }
    { name: \熱血, link: \fire.jpg }
    { name: \夏日, link: \beach.jpg }
    { name: \憂鬱, link: \bluemountain.jpg }
    { name: \燃燒, link: \burn.jpg }
    { name: \輝煌, link: \goldmountain.jpg }
    { name: \寬廣, link: \hiking.jpg }
    { name: \悲情, link: \night.jpg }
    { name: \遠洋, link: \sea.jpg }
    { name: \寧靜, link: \serenity.jpg }
    { name: \冷冽, link: \snow.jpg }
  ]
  $scope.background = $scope.backgrounds.0
  # lien version
  #pc = x: 0.134, y: 0.57, w: 0.58, h: 0.32
  pc = x: 0.180, y: 0.62, w: 0.40, h: 0.20
  canvas = document.getElementById("canvas")
  ctx = canvas.getContext("2d")
  hidecanvas = document.getElementById("hide-canvas")
  hctx = hidecanvas.getContext("2d")
  $scope.editBk = false
  chldr = $('#canvas-holder')
  chdd = {width: chldr.width!, height: chldr.height!}
  $('#canvas').attr \width, "#{chdd.width}px"
  $('#canvas').attr \height, "#{chdd.height}px"
  $('#hide-canvas').attr \width, "#{chdd.width}px"
  $('#hide-canvas').attr \height, "#{chdd.height}px"
  ctx.textBaseline = "hanging"

  lienImg = new Image!
  #lienImg.src = "lien-margin2.png"
  lienImg.src = "ko2.jpg"

  area = ( pc.w * pc.h * chdd.width * chdd.height )
  pw = chdd.width * pc.w
  ph = chdd.height * pc.h
  $scope.update-text = (ctx, noclear=false) ->
    if !noclear => ctx.clearRect 0, 0, chdd.width, chdd.height
    draw = ->
      totaltext = $scope.comment or ""
      [L,R] = [1,100]
      idx = 0
      # regression for font size
      while L < R and idx < 20
        idx++
        M = parseInt(( L + R ) / 2)
        ctx.font = "#{M}px Arial"
        len = ctx.measureText totaltext .width
        fs = parseInt(ph*0.9 / Math.ceil(0.001 + (len / pw* 0.9)))
        if M < fs => L = M + 1
        else R = M
      fsize = parseInt(M)

      textlen = ctx.measureText totaltext .width
      ctx.font = "#{fsize}px Arial"
      texts = []
      idx = 0
      # regression for text break
      while totaltext.length
        t = totaltext.substring 0, idx
        w = ctx.measureText t .width
        if w >= pc.w * chdd.width
          texts.push totaltext.substring 0, idx - 1
          totaltext = totaltext.substring idx - 1
          idx = 0
        else if idx >= totaltext.length =>
          texts.push totaltext.substring 0, idx
          totaltext = totaltext.substring idx
          break
        else => idx++
      tw = texts.map(-> it.length).sort((a,b) -> b - a)0 * fsize
      th = texts.length * fsize
      aw = ( pw - tw ) / 2
      ah = ( ph - th ) / 2
      aw >?= 0
      ah >?= 0

      ctx.drawImage lienImg, 0,0, chdd.width, chdd.height
      ctx.rotate(-3 * Math.PI/180)
      for t,index in texts
        ctx.fillText t, parseInt( chdd.width * pc.x + aw) , parseInt( chdd.height * pc.y + index * fsize + ah)
      ctx.rotate(3 * Math.PI/180)

    if !$scope.curbk =>
      return draw!
    bkimg = new Image!
    bkimg.src = $scope.curbk
    bkimg.onload = ->
      #ctx.clearRect 0, 0, chdd.width, chdd.height
      ctx.drawImage bkimg, 0, 0, chdd.width, chdd.height
      draw!
      #$scope.update-text ctx, true
      console.log canvas.toDataURL!

  $scope.$watch 'comment', -> $scope.update-text ctx, true
  $scope.$watch 'background', -> if $scope.{}background.link =>
    $scope.curbk = "bk/#{$scope.background.link}"
    #$(\#canvas-holder).css 'background-image', "url(bk/#{$scope.background.link})"
  /*$scope.$watch 'urlbackground', -> if $scope.urlbackground =>
    $scope.curbk = $scope.urlbackground
    #$(\#canvas-holder).css 'background-image', "url(#{$scope.urlbackground})"*/
  $scope.$watch 'filebackground', -> if $scope.filebackground =>
    fr = new FileReader!
    fr.onload = (e) -> 
      $scope.$apply -> $scope.curbk = e.target.result
      #$(\#canvas-holder).css 'background-image', "url(#{e.target.result})"
    e = document.getElementById("filebackground")
    fr.readAsDataURL(e.files[0])
  $scope.$watch 'curbk', -> $scope.update-text ctx, false

  $scope.generate = ->
    console.log canvas.toDataURL!

