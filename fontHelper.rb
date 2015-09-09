 # Copyright (c) 2015, Pablo Alcalde. All rights reserved.
 # Licensed under the MIT license <http://opensource.org/licenses/MIT>
 
 # Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 # documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 # the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 # to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 # The above copyright notice and this permission notice shall be included in all copies or substantial portions
 # of the Software.
 
 # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 # TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 # THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 # CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 # IN THE SOFTWARE.
 
class FontHelper
	attr_accessor :unicodes, :fontName, :saveDirectory

	def initialize (ttfPath, saveDirectory)
		@saveDirectory = saveDirectory
		@unicodes = `otfinfo -u #{ttfPath}`.split("\n")
		@fontName = `otfinfo --info #{ttfPath}`.split[1]
		puts "\nFontName is #{@fontName} \n"
	end

	def unicodesArray()
		unicodesStringArray = "@["
		@unicodes.each_with_index do |unicode, index|
			unicodeSplitted = unicode.split(" ")
			if !self.isValidUnicodeCharacter(unicodeSplitted[0]) then next end
			if unicodeSplitted.length == 3
				unicodeValue = unicodeSplitted[0]
				unicodeValue = unicodeValue.sub('uni', 'u')
				unicodesStringArray += '@"\\' + unicodeValue + '"'
				if index < @unicodes.length-1 then unicodesStringArray += ',' end
			end
		end
		unicodesStringArray += '];'
		return unicodesStringArray
	end

	def createImplementationFile()
		sample = File.open(File.dirname(__FILE__) + '/' + "sample.m")
		newFile = File.new(saveDirectory + '/' + "NSString+#{@fontName}.m", 'w');
		sample.each do |line|
			line = self.replaceFontNameForLine(line)
			if line.include? '<<UNICODES_ARRAY>>'
				line = line.sub('<<UNICODES_ARRAY>>', self.unicodesArray() + "\n")
			end
			newFile.write(line)
		end
		puts "\nCreated implementation file:\n"
		puts newFile.path + "\n\n"
	end

	def unicodesEnums()
		unicodesString = ''
		@unicodes.each_with_index do |unicode, index|
			unicodeSplitted = unicode.split(" ")
			if !self.isValidUnicodeCharacter(unicodeSplitted[0]) then next end
			if unicodeSplitted.length == 3
				unicodeName = unicodeSplitted[2]
				unicodesString += '    ' + @fontName + '_' + unicodeName
				if index < @unicodes.length-1 then unicodesString += ',' + "\n" end
			end
		end
		return unicodesString
	end

	def createHeaderFile()
		sample = File.open(File.dirname(__FILE__) + '/' +  "sample.h")
		newFile = File.new(saveDirectory + '/' + "NSString+#{@fontName}.h", 'w');
		sample.each do |line|
			line = self.replaceFontNameForLine(line)
			if line.include? '<<UNICODES_ENUM>>'
				line = line.sub('<<UNICODES_ENUM>>', self.unicodesEnums() + "\n")
			end
		newFile.write(line)
		end
		puts "\nCreated header file: \n"
		puts newFile.path + "\n\n"
	end

	def replaceFontNameForLine(line)
		newLine = line
		if line.include? '<<FONTNAME>>'	
			newLine = line.gsub('<<FONTNAME>>', @fontName) 
		end
		return newLine
	end

	def isValidUnicodeCharacter(uniChar) 
		case uniChar
		when 'uni0020' then return false
		when 'uniFFFF' then return false
		when 'uniF500' then return false
		else return true
		end
	end
end 

# Main

# Lets check if user already has the brew package lcdf-typetools which provides the otfinfo library used by this script.
otfInfoInstalledVersion = `otfinfo --version; true`
if otfInfoInstalledVersion.split[3].nil? || otfInfoInstalledVersion.split[3] < "2.104" 
	puts "You don't have otfinfo 2.104 installed"
	brewInstalled = !`brew --version; true`.include?('command not found')
	if brewInstalled
		puts "Trying to get otfinfo from homebrew, installing package lcdf-typetools.."
		`brew install lcdf-typetools`
	else 
		puts "Install homebrew and run this script again"
		exit
	end
end

ttfPath = nil 
saveDirectory = nil
if ARGV[0] && File.file?(ARGV[0]) then ttfPath = ARGV[0] end
if ARGV[1] && File.directory?(ARGV[1]) then saveDirectory = ARGV[1].chomp("/") end

if ttfPath && saveDirectory
	fontHelper =  FontHelper.new(ttfPath, saveDirectory)
	fontHelper.createHeaderFile
	fontHelper.createImplementationFile
else 
	if ttfPath.nil?
		puts "\nError: A valid path to a .ttf file must be provided as a first argument\n\n"
	elsif saveDirectory.nil?
		puts "\nError: A valid path to a directory where generated files will be saved must be provided as a second argument\n\n"
	end
exit
end