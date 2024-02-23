# Import required modules
from openai import OpenAI
from dotenv import load_dotenv

# Load .env file
load_dotenv()

# Create an instance of the OpenAI client
client = OpenAI()

# Function to generate completions from the model
def get_completion_from_messages(messages, model="gpt-4"):
    """
    This function generate completions from the model
    It takes two parameters:
    - messages: messages to generate completions for
    - model: the OpenAI model to use. Default is "gpt-4"
    """
  
    # Call OpenAI API to create completions
    response = client.chat.completions.create(
        model=model,
        messages=messages,
    )
  
    # Return the first completion
    return response.choices[0].message.content

# Function to collect messages and generate responses
def collect_messages(agent, file_name):
    """
    This function reads a file, generate messages and responses
    It takes two parameters:
    - agent: the agent to use for the messages
    - file_name: the name of the file to read 
    """
  
    # Open the file in reading mode
    with open(file_name, 'r') as file:
        # Read the file's content
        code = file.read()
        # Create messages
        messages = [
            {"role": "system", "content": agent},
            {"role": "user", "content": f"{code}"},
        ]

    # Get completion (response) from messages
    response = get_completion_from_messages(messages) 

    # Open a new file to write the response
    with open(f'{file_name}.temp', 'w') as new_file:
        # Write the response to the new file
        new_file.write(response)

# Main function
if __name__ == "__main__":
    # List of file names
    file_names = ["../terraform/main.tf", "../terraform/providers.tf", "../terraform/variables.tf"]

    # Agent details
    agent = f"""
            You are IT Expert. 
            - Modify provided files with adding comments as documentation.
            - Return the same file with extra content.
            - Use exact same programming format by file name from path (example ./main.tf for terraform)
            - Dont add any non nessesary text as ```python, file needs to be ready to run
            - Dont change code functionality

            Example for terraform:

            # module for resource group
            module "rg" {{
            source = "./modules/rg"

            postfix     = local.postfix
            project     = var.project
            environment = var.environment
            location    = var.location
            }}
            """
    
    
    # For each file name in the list
    for file_name in file_names:
        # collect messages and generate responses
        collect_messages(agent, file_name)

