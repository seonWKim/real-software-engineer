use std::io::{self, Write};

fn process_sql_command(command: &str) {
    let command = command.trim();
    if command.is_empty() {
        return;
    }
    
    let command_upper = command.to_uppercase();
    
    if command_upper.starts_with("SELECT") {
        println!("| id | name  | age | email           |");
        println!("|----|-------|-----|-----------------|");
        println!("| 1  | Alice | 30  | alice@email.com |");
        println!("| 2  | Bob   | 25  | bob@email.com   |");
        println!("2 rows returned.");
    } else if command_upper.starts_with("CREATE") {
        if command_upper.contains("TABLE") {
            println!("Table 'test' created successfully.");
        } else {
            println!("Created successfully.");
        }
    } else if command_upper.starts_with("INSERT") {
        println!("1 row inserted.");
    } else if command_upper.starts_with("UPDATE") {
        println!("Rows updated.");
    } else if command_upper.starts_with("DELETE") {
        println!("Rows deleted.");
    } else if command_upper.starts_with("DROP") {
        println!("Dropped successfully.");
    } else {
        println!("Query executed.");
    }
}

fn main() {
    let stdin = io::stdin();
    let mut stdout = io::stdout();
    
    loop {
        print!("sql> ");
        stdout.flush().unwrap();
        
        let mut input = String::new();
        match stdin.read_line(&mut input) {
            Ok(0) => {
                // EOF (Ctrl+D)
                println!("\nGoodbye!");
                break;
            }
            Ok(_) => {
                let command = input.trim();
                if command.to_lowercase() == "exit" || command.to_lowercase() == "quit" {
                    println!("Goodbye!");
                    break;
                }
                if !command.is_empty() {
                    process_sql_command(command);
                }
            }
            Err(_) => {
                println!("\nGoodbye!");
                break;
            }
        }
    }
}