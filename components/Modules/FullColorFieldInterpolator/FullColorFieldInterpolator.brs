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
end sub

sub onKeyValueChange(event)
end sub

sub onFractionChange(event)
  m.targetNode
end sub

sub updateColorTransition()
end sub