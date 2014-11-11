main = ($scope, $timeout) ->
  canvas = document.getElementById("canvas")
  ctx = canvas.getContext("2d")
  img = new Image!
  img.src = "lien.png"
  rhptr = null

  resize-canvas = ->
    [w,h] = [$(\#canvas-html)width!, $(\#canvas-html)height!]
    [cw,ch] = [w,h]
    w <?= h
    h <?= w
    [bw,bh] = [w * 0.63, h * 0.39]map(-> parseInt(it))
    ctx.drawImage img, parseInt((cw - w)/2),0,w,h

    fs = bw
    r = fs / 2
    while r > 0.5
      count = (bw / fs) * (bh / fs)
      if count < $scope.text.length =>
        fs -= r
      else fs += r
      r = r * 0.5
    console.log "字型大小:", fs
    fs <?= bw / 5
    ctx.font = "#{fs}px Arial"

    text = otext = $scope.text
    texts = []
    i = 1
    while otext.length
      text = otext.substring(0,i)
      tw = ctx.measureText(text).width
      if i >= otext.length or tw >= bw * 0.9 =>
        texts.push(text)
        if i>=otext.length => break
        otext = otext.substring(i)
        i = 0
      i++

    y = (bh - texts.length * fs ) / 2
    i = 0
    ctx.rotate(-4 * Math.PI/180)
    for t in texts
      ctx.fillText t, cw/2 - bw * 0.6, ch * 0.65 + y + i * fs
      i++
    ctx.rotate(4 * Math.PI/180)

    $(\#textbox).css do
      width: "#{bw}px"
      height: "#{bh}px"
      left: "#{cw/2 - bw * 0.6}px"
      top: "#{ch / 2}px"
      opacity: 1
      fontSize: "#{fs}px"

  resize-handler = ->
    rhptr := null
    [w,h] = [$(\#canvas-html)width!, $(\#canvas-html)height!]
    [cw,ch] = [w,h]
    w <?= h
    h <?= w
    [bw,bh] = [w * 0.63, h * 0.39]map(-> parseInt(it))

    $(\#canvas).attr do
      width: "#{cw}px"
      height: "#{ch}px"
    $(\#canvas).css do
      width: "#{cw}px"
      height: "#{ch}px"
    $timeout resize-canvas, 100

  $(window).resize -> 
    if rhptr => 
      $timeout.cancel rhptr
    rhptr := $timeout resize-handler, 100
  $scope.text = "我是連勝文大家好我是連勝文大家好我是連勝文大家好"
  $timeout resize-handler, 100
  $scope.$watch 'text', -> resize-handler!
