sub init()
  top = m.top

  m.left = top.findNode("left")
  m.right = top.findNode("right")
  m.anim = top.findNode("anim")
  m.cfi = top.findNode("cfi")
  m.fcfi = top.findNode("fcfi")

  m.left.update({
    width: 960,
    height: 1080,
    translation: [0, 0]
  })

  m.right.update({
    width: 960,
    height: 1080,
    translation: [960, 0]
  })

  m.anim.update({
    duration: 20,
    repeat: true,
    easeFunction:"linear"
  })

  ' m.cfi.update({
  '   fieldToInterp: "right.color"
  '   key: [0, 0.5, 1]
  '   keyValue: ["0xFF0000FF", "0x0000FFFF", "0x00FF00FF"]
  ' }, false)

  ' m.fcfi.update({
  '   fieldToInterp: "left.color"
  '   key: [0, 0.5, 1]
  '   keyValue: ["0xFF0000FF", "0x0000FFFF", "0x00FF00FF"]
  ' })

  keys = [0, 0.5, 1]
  keyValues = ["0xFFFFFFFF", "0xFFFF00FF", "0xFF00FFFF"]

  m.cfi.update({
    fieldToInterp: "right.color"
    key: keys
    keyValue: keyValues
  }, false)

  m.fcfi.update({
    fieldToInterp: "left.color"
    key: keys
    keyValue: keyValues
  })

  m.anim.control = "start"
end sub
