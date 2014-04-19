function equivalentResistance = parseResistance( varargin )
%PARSERESISTANCE takes in a string and computes the equivalent resistance
%of the string notation for a circuit. E.g. (R1 + R2)//R3 means R1 in
%series with R2, all parallel to R3.

if(isempty(varargin))
    inputString = input('Enter the circuit resistance layout:', 's');
    equivalentResistance = parseBrackets(inputString);
else
    inputString = varargin{1};
    equivalentResistance = parseBrackets(inputString);
end

end

% Parses a bracket statement (expression with or without brackets)
function result = parseBrackets( inputString )

    bracketIndices = strfind(inputString, '(');
    
    % If there are brackets, recursively evaluate
    while(~isempty(bracketIndices))
        
        openBracket = 0;
        startIndex = bracketIndices(1);
        
        for(i = startIndex:length(inputString))
            if(inputString(i) == '(')
                openBracket = openBracket + 1;
            end
            
            if(inputString(i) == ')')
                openBracket = openBracket - 1;
            end
            
            if openBracket == 0
                endIndex = i;
                subString = inputString(startIndex+1:endIndex-1);
                
                break;
            end
        end
        
        newString = strrep(inputString, inputString(startIndex:endIndex), ...
            num2str(parseBrackets(subString)));
        
        disp(['Solving... ' inputString ...
                    ' = ' newString]);
                
        inputString = newString;
        
        bracketIndices = strfind(inputString, '(');
    end
    
    %If no brackets in inputString left, evaluate Sum statements
    result = parseSum(inputString);
    
end

% Parses a Sum statement, where Sum::=Parallel([+-]Parallel)*
function result = parseSum( inputString )
    nodes = regexp(inputString, '[+-]', 'split');
    
%     %If no addition statements, return the evaluated Parallel expression.
%     if(length(nodes) == 1)
%         result = inputString;
%         return;
%     end
    
    for node = nodes
        subString = node{1};
        
        inputString = strrep(inputString, subString, ...
            num2str(parseParallel(subString)));
    end
    
    result = eval(inputString);

end

% Parses a Parallel statement, where Parallel::=Product(//Product)*
function result = parseParallel( inputString )
    nodes = regexp(inputString, '\/\/', 'split');
    
%     %If no addition statements, return the evaluated Parallel expression.
%     if(length(nodes) == 1)
%         result = parseProduct(inputString);
%         return;
%     end
%     
    sum = 0;
    
    for node = nodes
        subString = node{1};
        sum = sum + 1/(parseProduct(subString));
    end
    
    result = 1/sum;
end

% Parses a Product statement, where Product::=Number([\*\/]Number)*
function result = parseProduct( inputString )
    result = eval(inputString);
end