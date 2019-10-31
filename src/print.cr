require "colorize"
def print(any)
    puts any
end

def print_warn(any)
    puts any.colorize(:yellow)
end

def print_error(any)
    puts any.colorize(:red)
end

def print_log(any)
    puts any.colorize(:aqua)
end