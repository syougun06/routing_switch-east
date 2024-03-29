require 'graphviz'

module View
  # Topology controller's GUI (graphviz).
  class Graphviz
    def initialize(output = 'topology.png')
      @output = output
      @switch_nodes = {}
      @host_nodes = []
      @edges = []
    end

    # rubocop:disable AbcSize
    def update(_event, _changed, topology)
      @switch_nodes.clear
      @host_nodes.clear
      @edges.clear

      @switch_nodes = topology.switches.each_with_object({}) do |each, tmp|
        tmp[each] = each.to_hex
      end

      @edges = topology.hosts.each_with_object([]) do |each, tmp|
        mac_address, ip_address, dpid, port_no = each
        @host_nodes << ip_address.to_s
        tmp << [ip_address.to_s, dpid.to_hex]
      end

      @edges.concat (
        topology.links.each_with_object([]) do |each, tmp|
          tmp << [@switch_nodes[each.dpid_a], @switch_nodes[each.dpid_b]]
        end
      )

      generate_graph
    end
    # rubocop:enable AbcSize

    def generate_graph(red_edges = [])
      GraphViz.new(:G, use: 'neato', overlap: false, splines: true) do |gviz|
        @switch_nodes.map do |key, node|
          gviz.add_nodes node, shape: 'box'
        end
        @host_nodes.each do |node|
          gviz.add_nodes node, shape: 'ellipse'
        end
        @edges.each do |edge|
          gviz.add_edges edge[0], edge[1], dir: "none" unless red_edges.include?(edge) || red_edges.include?(edge.reverse)
        end
        red_edges.each do |edge|
          gviz.add_edges edge[0], edge[1], dir: "none", color: "red"
        end
        gviz.output png: @output
      end
    end

    def update_shortest_path(shortest_path)
      red_edges = []

      shortest_path.each_slice(2) { |edge|
        edge.each_with_index { |node, i|
          edge[i] = node.kind_of?(Pio::IPv4Address) ? node.to_s : node.dpid.to_hex
        }
        red_edges << edge
      }

      generate_graph red_edges
    end

    def to_s
      "Graphviz mode, output = #{@output}"
    end
  end
end
