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
    m.targetFieldName = nodeField
    m.targetField = m.targetNode[nodeField]
  else
    m.targetNode = Invalid
    m.targetField = Invalid
    m.targetFieldName = Invalid
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
  curIndex = 0

  if Invalid <> self.key AND Invalid <> self.keyValue
    for each key in self.key
      if fraction > key AND (Invalid = m.top.reverse OR false = m.top.reverse)
        curIndex = index
      else if fraction < key AND true = m.top.reverse
        curIndex = index
      end if
      index++
    end for

    if Invalid <> self.keyValue[curIndex] AND Invalid <> m.colorDelta[curIndex]
      startColor = convertColor(self.keyValue[curIndex])
      delta = (fraction - self.key[curIndex]) * m.colorDelta[curIndex].delta

      r = startColor.r + (m.colorDelta[curIndex].r * delta)
      g = startColor.g + (m.colorDelta[curIndex].g * delta)
      b = startColor.b + (m.colorDelta[curIndex].b * delta)
      a = startColor.a + (m.colorDelta[curIndex].a * delta)

      ' ?fraction, fraction - self.key[curIndex], delta, StrI(r, 16), StrI(g, 16), StrI(b, 16), StrI(a, 16)

      m.targetNode[m.targetFieldName] = (r << 24) + (g << 16) + (b << 8) + (a << 0)
    end if
  end if
end sub

sub updateColorTransition(self)
  m.colorDelta = []

  first = true
  index = 0

  if self.key.count() <> self.keyValue.count()
    return
  end if

  for each colorChange in self.keyValue
    if false = first AND 0 < self.key[index]
      curColor = convertColor(colorChange)

      rDelta = curColor.r - prevColor.r
      gDelta = curColor.g - prevColor.g
      bDelta = curColor.b - prevColor.b
      aDelta = curColor.a - prevColor.a

      keyDelta = self.key[index] - self.key[index-1]

      m.colorDelta.push({r: rDelta, g: gDelta, b: bDelta, a: aDelta, delta: 1/keyDelta})
      prevColor = curColor
    else
      first = false

      prevColor = convertColor(colorChange)
    end if

    index++
  end for
end sub

function convertColor(inColor)
  r = 0
  g = 0
  b = 0
  a = 255

  if Invalid = inColor
    return {r: r, g: g, b: b, a: a}
  end if

  if 0 <> instr(0, lcase(type(inColor)), "string")
    ' ?"String"
  else
    r = &h000000FF AND inColor >> 24
    g = &h000000FF AND inColor >> 16
    b = &h000000FF AND inColor >> 8
    a = &h000000FF AND inColor
  end if

  return {r: r, g: g, b: b, a: a}
end function