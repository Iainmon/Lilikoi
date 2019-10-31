require "json"
require "forloop"
require "./entry.cr"

module Lilikoi

    alias CodableFruitRequest = Hash(String, Hash(String, Hash(String, String) | Array(String) | Array(Hash(String, String))))

    alias FruitActionBundle = Hash(String, Hash(String, String) | Array(String) | Array(Hash(String, String)))

    # A request template for manipulating data
    class Fruit

        private class ActionContainer

            property link_field : String
            property link_value : String

            property identifier = ""

            property to_look = Array(String).new
            property to_modify = Array(Hash(String, String)).new
            property to_remove = Array(String).new

            property collected_values = Hash(String, String).new

            def initialize(actions : FruitActionBundle)
                @link_field = actions["link"].to_h["field"].to_s
                @link_value = actions["link"].to_h["value"].to_s
                
                if actions.has_key?("look")
                    if actions["look"].size > 0
                        actions["look"].each do |look_address|
                            @to_look << look_address.to_s
                        end
                    end
                end

                if actions.has_key?("modify")
                    if actions["modify"].size > 0
                        actions["modify"].each do |modify_instruction|
                            @to_modify << modify_instruction.as(Hash(String, String))
                        end
                    end
                end

                if actions.has_key?("remove")
                    if actions["remove"].size > 0
                        actions["remove"].each do |remove_address|
                            @to_remove << remove_address.to_s
                        end
                    end
                end

            end

            def act(vine : Vine)
                @identifier = find_identifier(vine)
                run_look(vine) if @to_look.size > 0
                run_modify(vine) if @to_modify.size > 0
                run_remove if @to_remove.size > 0
                return @collected_values
            end

            def run_look(vine : Vine)
                for address_to_find in @to_look do
                    value = vine.retrive_from_key(address_to_find, @identifier)
                    value = "Unable to find #{address_to_find}." if value.nil?
                    @collected_values[address_to_find] = value
                end
            end

            def run_modify(vine : Vine)
                for modification_instruction in @to_modify do
                    vine.store(modification_instruction["field"], @identifier, modification_instruction["value"])
                end
            end

            def run_remove

            end

            private def find_identifier(vine : Vine) : String
                identifier = vine.retrive_from_unique_value(@link_field, @link_value)
                @collected_values["identification_error"] = "Unable to identify #{@link_field} with #{@link_value}." if identifier.nil?
                raise "Unable to find identifier." if identifier.nil?
                return identifier.to_s
            end
        end



        property errors = Array(String).new

        property actor : ActionContainer | Nil = nil

        property values = Hash(String, String).new

        def initialize(encoded_fruit_request : String)
            begin
                @actor = ActionContainer.new decode_fruit_request(CodableFruitRequest.from_json(encoded_fruit_request))
            rescue exception
                puts exception.message
                message = exception.message
                if message.nil?
                    message = "Unable to parse the JSON request."
                else
                    message += " (Error parsing JSON request)."
                end
                @errors << message
            end
        end

        def run(vine : Vine)
            return nil if @actor.nil?
            @values = @actor.not_nil!.act(vine)
        end

        def respond
            build_error if @errors.size > 0

            build_response
        end

        private def build_response() : String
            response_json = JSON.build do |json|
                json.object do
                    json.field "error", false
                    json.field "data" do
                        json.array do
                            @values.each_key do |value_key|
                                json.object do
                                    json.field value_key.to_s, @values[value_key]
                                end
                            end
                        end
                    end
                end
            end
            response_json
        end

        private def build_error() : String
            error_json = JSON.build do |json|
                json.object do
                    json.field "error", true
                    json.field "messages" do
                        json.array do
                            @errors.each do |error|
                                json.string error
                            end
                        end
                    end
                end
            end

            error_json
        end

        private def decode_fruit_request(request : CodableFruitRequest) : FruitActionBundle

            bundle = FruitActionBundle.new
            bundle["link"] = request["request"]["link"].clone
            bundle["look"] = request["request"]["look"].clone if request["request"].has_key?("look") && request["request"]["look"].size > 0
            bundle["modify"] = request["request"]["modify"].clone if request["request"].has_key?("modify")
            bundle["remove"] = request["request"]["remove"].clone if request["request"].has_key?("remove")

            bundle

        end
    end
end