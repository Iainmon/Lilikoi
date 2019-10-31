require "./stem.cr"
require "./entry.cr"
require "forloop"
require "json"
require "random"

module Lilikoi

    alias SchemaType = Hash(String, Hash(String, Array(String)))

    class Vine < Stem

        property branch_prefixes = Array(String).new

        def initialize(branches_to_load : Hash(String, Array(String)))

            branches_to_load.each_key do |branch_prefix|

                @branch_prefixes << branch_prefix

                branch_identifier_name = branch_prefix + "._identifier"
                @branches[branch_identifier_name] = EntryList.new

                branches_to_load[branch_prefix].each do |branch_name|
                    @branches["#{branch_prefix}.#{branch_name}"] = EntryList.new
                end
            end

        end

        def create(branch_prefix : String, field_values : Hash(String, String))
            raise "Branch '#{branch_prefix}' does not exist!" unless branch_prefix_exists?(branch_prefix)

            # Creates a new identifier for this new object
            identifier_branch = @branches["#{branch_prefix}._identifier"]
            next_index = identifier_branch.last_key?
            next_index = 0_u32 if next_index.nil?
            next_identifier = generate_random_index(branch_prefix)
            identifier_branch[next_index] = next_identifier
            # store("#{branch_prefix}._identifier", next_index, next_identifier)

            identifier = next_identifier
            field_values.each_key do |key|
                branch_name = "#{branch_prefix}.#{key}"
                raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
                @branches[branch_name][identifier] = field_values[key].to_s
            end

            identifier
        end

        def branch_prefix_exists?(branch_prefix : String)
            prefix_exists = false
            for prefix in @branch_prefixes do
                if branch_prefix == prefix
                    prefix_exists = true
                    break
                end
            end
            prefix_exists
        end

        private def generate_random_index(branch_prefix : String) : String
            key = Random::Secure.hex(8)
            key = generate_random_index(branch_prefix) unless @branches["#{branch_prefix}._identifier"].key_for?(key).nil?
            key
        end

        def self.branches_from_schema_file(schema_file_location = "./config/schema.json") : Hash(String, Array(String))
            schema = SchemaType.from_json(File.read(schema_file_location))
            return schema["branches"]
        end
    
    end
end