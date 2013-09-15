module Video::Model::Auth::Member
  def creatable?
    return true
  end

  def readable?
    return true
  end

  def editable?
    return true
  end

  def deletable?
    return true
  end
end