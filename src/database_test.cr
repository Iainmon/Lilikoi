
module Lilikoi
    def self.create_populated_vine_database(schema_file_location = "./config/schema.json") : Vine

        print("Populating test database...")

        schema = Hash(String, Hash(String, Array(String))).from_json(File.read(schema_file_location))
    
        vine_branches = schema["branches"]
    
        vine = Vine.new vine_branches
        
        new_user_values = {
            "username" => "iainmoncrief",
            "email" => "exampleemail@example.com"
        }
        vine.create("users", new_user_values)

        return vine
    end

    def self.test_stem
        branch_names = [
            "branch.one",
            "branch.two"
        ]
    
        stem = Stem.new branch_names
    
        stem.store("branch.one", "0x01", "Hello World!")
    
        print(stem.branches)
    
        print(stem.retrive("branch.one", "0x01"))
    end
    
    def self.test_vine
    
        print("Testing database initializer...")
    
        schema = Hash(String, Hash(String, Array(String))).from_json(File.read("./config/schema.json"))
    
        vine_branches = schema["branches"]
    
        vine = Vine.new vine_branches
    
        print("Database initialized.")
    
        print(vine.branches)
    
        new_user_values = {"username" => "iainmoncrief"}
        vine.create("users", new_user_values)
    
        print(vine.branches)
    
    end
end