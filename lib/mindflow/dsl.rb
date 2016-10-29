require_relative 'dsl/base_node'
require_relative 'dsl/root_node'
require_relative 'dsl/class_node'
require_relative 'dsl/method_node'

module Mindflow
  module Dsl
  end
end
# m Posthire
#   m Background
#     cl Check
#     d to_s
#     d close!
#     cl Rule
#     p app/services
#       CreateService
#       DeleteService
#   m DataCollection
#     cl Check
#       cl CreationException no_file
#     cl Rule
