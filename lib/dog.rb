require 'pry'
class Dog
attr_accessor :name, :breed, :id

        
        def attributes (name, breed) 
             @name 
             @breed 
             @id 
        end 
        
        def initialize(id:nil,name:"Fido",breed:"lab")
        @id = id
        @name = name
        @breed = breed
        end
        
        
       def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS dogs (
              id INTEGER PRIMARY KEY,
              name TEXT,
              breed TEXT
            )
            SQL
        
            DB[:conn].execute(sql)
          end

          def self.drop_table
            sql =  <<-SQL 
            DROP TABLE dogs
            SQL
            DB[:conn].execute(sql)
          end
        
        
          def save
            if self.id
              self.update 
            else
              sql = <<-SQL
              INSERT INTO dogs (name, breed) 
            VALUES (?, ?)
          SQL
          DB[:conn].execute(sql, self.name, self.breed)
          @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
          end
          end 

            def self.new_from_db(row)
                dogs = self.new
                dogs.id = row[0]
              dogs.name = row[1]
              dogs.breed = row [2]
              dogs
              end
          
  

# def self.create(id,name, breed)
#     dogs = Dog.new(id, name, breed)
#     binding.pry
#     dogs.save
#     dogs
# end

def self.find_by_name(name)
    sql = <<-SQL
  SELECT *
  FROM dogs
  WHERE name = ?
  LIMIT 1
  SQL
  DB[:conn].execute(sql, name).map do |row|
    self.new_from_db(row)
  end.first 
  end

def update
    sql = "UPDATE dogs SET name = ?, breed = ? "
      DB[:conn].execute(sql, self.name, self.breed)
    end
  

end
