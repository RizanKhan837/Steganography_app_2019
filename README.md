# MIPSSteganoAsm_2019
MIPS Steganography Assembler

I.Encode
-Ask the user to enter a filename (in BMP).
-Ask the user a string to encode.
-Ask the filename of the new file.
-Save the file in the filename

1(bis). Size of string
1. Put string into bits
bits[] // malloc if needed with (n char x 8)
for (i = 0; i != str.length; i++) {
    nb = charToNb 
    (if nb > 255 = ' ')
    for (j = 7; j >= 0; j--) { // nb to bit
        bits[i * 8 + 7 - j] = (number >> j) & 1
}
2. Get start for encode (after header)
3. Encode the stringBits into the img
4. Put end for encode

To encode we will use the "lsb" least signifcicant bit.
We will only take img with real colors on 24bits (8 bits / 1 octet for one color) -> Blue -> Green -> Red
Hide the last bit of each color next to eachother until end of the string.

for example:
octet[pixel][color] = 11010011 && (char = 'a == 01100001)
    if (a[0] = 0)
        octet[pixel][color] = 0
    else
        continue

II.Decode
-Choose a file image.
-Show the sentence encode.

1. Put Bits into string
string str
int c
for (j = 0; i = 0; l != bits.length; i += 8, j++) {
    c = 0
    for (var j = 7; j >= 0; j--)
        c = bits[i + 7 -j] << j
    str[j] = String.fromCharCode(c)
} 