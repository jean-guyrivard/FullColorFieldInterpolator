sub init()
  top = m.top

  top.observeFieldScoped("fieldToInterp", "onFieldToInterpChange")
  top.observeFieldScoped("key", "onKeyChange")
  top.observeFieldScoped("keyValue", "onKeyValueChange")
  top.observeFieldScoped("fraction", "onFractionChange")
end sub

sub onFieldToInterpChange(event)
  field = event.getData()
  dot = inStr(1, field, ".")

  if 0 <> dot AND Invalid <> m.top.getScene()
    nodeId = left(field, dot-1)
    m.targetNode = m.top.getScene().findNode(nodeId)
    nodeField = mid(field, dot+1)
    m.targetField = m.targetNode[nodeField]
  else
    m.targetNode = Invalid
    m.targetField = Invalid
  end if
end sub

sub onKeyChange(event)
  self = event.getRoSGNode()

  updateColorTransition(self)
end sub

sub onKeyValueChange(event)
  self = event.getRoSGNode()

  updateColorTransition(self)
end sub

sub onFractionChange(event)
  fraction = event.getData()
  self = event.getRoSGNode()
  index = 0

  for each key in self.key
    if fraction > key
    end if
  end for
  startColor = convertColor(self.keyValue[index])

  r = startColor.r + (m.colorDelta.r * fraction) * &hff000000
  g = startColor.g + (m.colorDelta.g * fraction) * &h00ff0000
  b = startColor.b + (m.colorDelta.b * fraction) * &h0000ff00
  a = startColor.a + (m.colorDelta.a * fraction) * &h000000ff

  m.targetField = r + g + b + a
end sub

sub updateColorTransition(self)
  m.colorDelta = []

  first = true
  index = 0
  for each colorChange in self.keyValue
    if false = first
      curColor = convertColor(colorChange)

      rDelta = (prevColor.r - curColor.r) / (self.key[1] - self.key[0])
      gDelta = (prevColor.g - curColor.g) / (self.key[1] - self.key[0])
      bDelta = (prevColor.b - curColor.b) / (self.key[1] - self.key[0])
      aDelta = (prevColor.a - curColor.a) / (self.key[1] - self.key[0])

      m.colorDelta.push({r: rDelta, g: gDelta, b: bDelta, a: aDelta})
    else
      first = false
    end if

    prevColor = convertColor(colorChange)
    index++
  end for
end sub

function convertColor(inColor)
  r = 0
  g = 0
  b = 0
  a = 255

  if 0 <> instr(0, lcase(type(inColor)), "string")
    ?"String"
  else
    r = &h000000FF AND inColor >> 24
    g = &h000000FF AND inColor >> 16
    b = &h000000FF AND inColor >> 8
    a = &h000000FF AND inColor
  end if

  return {r: r, g: g, b: b, a: a}
end function