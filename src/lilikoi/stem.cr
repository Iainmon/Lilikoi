require "forloop"
require "./entry.cr"

module Lilikoi

    class Stem

        property branches = Hash(String, EntryList).new

        def initialize; end

        def initialize(branch_names : Array(String))
            for branch_name in branch_names do
                create_branch(branch_name)
            end
        end

        def entry_exists?(branch_name : String, key : String) : Bool
            raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
            return @branches[branch_name].has_key?(key)
        end

        def retrive_from_key(branch_name : String, key : String)
            return retrive(branch_name, key)
        end

        def retrive(branch_name : String, key : String)
            raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
            return @branches[branch_name][key]?
        end

        def retrive_from_unique_value(branch_name : String, value : String)
            raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
            return @branches[branch_name].key_for?(value)
        end

        def store(branch_name : String, key : String, value : String)
            store(branch_name, Entry.new(key: key, value: value))
        end

        def store(branch_name : String, data : Entry)
            raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
            @branches[branch_name][data[:key].to_s] = data[:value]
        end

        def remove(branch_name : String, key : String | UInt32)
            raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
            @branches[branch_name].delete(key)
        end

        def create_branch(branch_name : String)
            raise "Branch '#{branch_name}' already exists!" if branch_exists?(branch_name)
            @branches[branch_name] = EntryList.new
        end

        def remove_branch(branch_name : String)
            raise "Branch '#{branch_name}' does not exist!" unless branch_exists?(branch_name)
            @branches.delete(branch_name)
        end

        def branch_exists?(branch_name : String)
            @branches.has_key?(branch_name)
        end

    end
end