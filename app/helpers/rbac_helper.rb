# TODO: Escape node titles with the equivalent of RoR's h()
module RbacHelper
  # This method helps the rbac/* controller to render a ActiveRecord tree.
  # that uses "acts_as_tree". You only pass the record array with the nodes 
  # to display and optionally a block to format the node output.
  def node_tree(nodes, &block)

    nodes = nodes.dup
    printed_nodes = []

    result = "<ul>"

    # top level nodes first, then others
    for node in nodes
      next unless node.parent == nil
      printed_nodes << node
      result += "<li>"

      if block_given?
        result += yield node
      else
        result += node.title
      end

      children = node.children.dup
      children.delete_if { |r| not nodes.include?(r) }
      if not children.empty?
        result += node_tree_help(children, nodes, printed_nodes, &block)
      end

      result += "</li>"
    end

    # TODO: Add depth counting here to get a minimum of trees
    for node in nodes
      next if printed_nodes.include? node
      printed_nodes << node

      result += "<li>"

      if block_given?
        result += yield node
      else
        result += node.title
      end

      children = node.children.dup
      children.delete_if { |r| not nodes.include?(r) }

      if not children.empty?
        result += node_tree_help(children, nodes, printed_nodes, &block)
      end

      result += "</li>"
    end

    result += '</ul>'

    return result
  end


  protected
  def node_tree_help(children, nodes, printed_nodes, &block) # :nodoc:
    result = '<ul>'
    for child in children
      next if printed_nodes.include?(child)
      printed_nodes << child

      result += '<li>'

      if block_given?
        result += yield child
      else
        result += child.title
      end

      children2 = child.children.dup
      children2.delete_if { |r| not nodes.include?(r) }
      if not children2.empty?
        result += node_tree_help(children2, nodes, printed_nodes, &block)
      end

      result += '</li>'
    end

    result += '</ul>'
  end

  def level_count(node) # :nodoc:
    counts = [0]
    node.children.each { |n| counts <<  1 + level_count(n) }
    return counts.max
  end


  protected  

  def log_error(exception) 
    super(exception)

    begin
      ErrorMailer.deliver_snapshot(
      exception, 
      clean_backtrace(exception), 
      @session.instance_variable_get("@data"), 
      @params, 
      @request.env)
    rescue => e
      logger.error(e)
    end
  end
end
