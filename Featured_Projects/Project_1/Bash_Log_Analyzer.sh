# # Version 1.0
# # Creating an array that searches current dir and stores element in search_for_log_files 

# mapfile -t search_for_log_files < <(find . -name '*.log')

# # For this version of my script users will only be able to analyze log files that have the following Universal Technical Error Keywords i.e Error, Fatal, Critical, Warning.
# # Down the line users should be able to input keywords they want to analyze for.

# # Using for loop and calling all element in search_for_log_files array to analyze them. 
# for file in "${search_for_log_files[@]}"; do

# # Used the -i flag to ignore CASE SENSITIVITY
#     error_log=$(grep -i "ERROR" $file)
#     warning_log=$(grep -i "WARNING" $file)
#     fatal_log=$(grep -i "FATAL" $file)
#     critical_log=$(grep -i "CRITICAL" $file)
#     failed_log=$(grep -i "CRITICAL" $file)

#     number_of_error=$(grep -ic 'ERROR' $file)
#     number_of_warning=$(grep -ic 'WARNING' $file)
#     number_of_critical=$(grep -ic 'CRITICAL' $file)
#     number_of_fatal=$(grep -ic 'FATAL' $file)
#     number_of_failed=$(grep -ic 'FAILED' $file)

#     echo -e "\n===================== Error Log for $file =======================\n\n$error_log "
#     echo -e "\nNumber of ERROR found in $file : $number_of_error "
    
#     echo -e "\n===================== WARNING Log for $file ======================\n\n$warning_log "
#     echo -e "\nNumber of WARNING found in $file : $number_of_warning "

#     echo -e "\n===================== FATAL Log for $file =====================\n\n$warning_log "
#     echo -e "\nNumber of FATAL found in $file : $number_of_fatal "

#     echo -e "\n===================== CRITICAL Log for $file =====================\n\n$warning_log "
#     echo -e "\nNumber of CRITICAL found in $file : $number_of_critical "

#     echo -e "\n===================== WARNING Log for $file =====================\n\n$failed_log "
#     echo -e "\nNumber of WARNING found in $file : $number_of_failed "
    
# done

# echo -e "\n========= End ========="

# -------------------------------------------------------------------------------------------------


# Version 1.1
# For this version of should be able to inpute elements they want to analyze for in searched log files.
# Users can also go with the default common errors.

# Creating an array that searches current dir, find and stores element in search_for_log_files 
mapfile -t search_for_log_files < <(find . -name '*.log')

# Creating a txt file to save reports in
report_file="./analysis_report.txt"

echo -e "\nLog Analyzer - Analyze Keyword Errors in your Log Files" 
echo "=======================================================" 
echo "" >> "$report_file"
echo "Choose an option:" >> "$report_file" 
echo "1) Search for common errors keywords (ERROR, WARNING, FATAL, CRITICAL FAILED)" 
echo "2) Enter custom keywords" 
echo "3) Exit" 
echo "" 
read -p "Enter choice [1-3]: " choice 

# Displays Options for users to select from
case $choice in
    1)
        keywords=("ERROR" "WARNING" "FATAL" "CRITICAL" "FAILED" )
        ;;
    2)
        echo -e "\nEnter keywords you want to analyze for. (separate by spaces):" 
        read -a keywords
        ;;
    3)
        echo "Exiting..." 
        exit 0
        ;;
    *)  
        echo "Invalid choice. Exiting..." 
        exit 1
        ;;
esac

echo "" 
echo "Searching for: ${keywords[@]}"

# Using for loop and calling all element in search_for_log_files array to analyze them. 
for file in "${search_for_log_files[@]}"; do
    echo -e "\n=== Analyzed: $file ===" >> "$report_file"

    # using loop to search through each keywords
    for keyword in "${keywords[@]}"; do
        keyword_error=$(grep -i $keyword $file)
        keyword_error_count=$(grep -ic "$keyword" "$file")
        
        if [ $keyword_error_count -gt 0 ]; then
            echo -e "\n=== $keyword Log for $file ===\n\n$keyword_error " >> "$report_file"
            echo -e "\nNumber of $keyword found in $file : $keyword_error_count " >> "$report_file"
        else
            echo -e "\nNo matches found for $keyword" >> "$report_file"
        fi
    done
done

echo -e "\n========= End =========" >> "$report_file"

echo -e "\nLog analysis completed. Results saved in $report_file"