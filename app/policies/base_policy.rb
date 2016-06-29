class BasePolicy
  # def pundit_user
  #   current_client
  # end

  private
  def has_scope? (client, permission, scope = nil)
    return false if client.nil?
    if scope.nil?
      return client.has_role? permission
    else
      return ( client.has_role? permission, scope )
    end
  end

  def has_at_least_one_scope (client, scopes)
    return false if client.nil?
    scopes.each do |scope|
      return true if has_scope?(client, scope[0], scope[1])
    end
    return false
  end
end