import re

def convert_line(line):
    # Match pattern like: 000 : sreg <= 16'hFF_01;
    match = re.search(r"16'h([0-9A-Fa-f_]+)", line)
    if match:
        hex_value = match.group(1).replace("_", "")
        return hex_value.upper()
    return None


# Example usage
input_file = "input.txt"
output_file = "output.txt"

with open(input_file, "r") as fin, open(output_file, "w") as fout:
    for line in fin:
        result = convert_line(line)
        if result:
            fout.write(result + "\n")

print("Done converting!")
