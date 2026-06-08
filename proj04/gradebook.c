#include "gradebook.h"
#include <string.h>

/*
 * Name: Devin Fromond
 */

struct Gradebook gradebook;

/**
 * Converts a major enum to a major string
 * 
 * @param major The enum representing Major
 * @return char* form of major
*/
const char* majorToString(enum Major major) {
  switch(major) {
    case 0:
      return "CS";
    case 1:
      return "CE";
    case 2:
      return "EE";
    case 3: 
      return "IE";
    default:
      return "Something broke...";
  }
}

/**
 * Adds a new student to the gradebook and sets all the student's grades to 0.
 *
 * Updates assignment_averages and course_average based on the new grades.
 *
 * @param name The name of the student.
 * @param gtid The GTID of the student.
 * @param year The year of the student.
 * @param major The major of the student.
 * @return SUCCESS if the student is added, otherwise ERROR if the student can't
 * be added (duplicate name / GTID, no space in gradebook, invalid major).
 */
int add_student(char* name, int gtid, int year, char* major) {  
  // if gradebook is out of space, ERROR
  if (gradebook.size >= MAX_ENTRIES) {
    return ERROR; 
  }

  // if name or major is null, ERROR
  if(name == NULL || major == NULL) {
    return ERROR; 
  }

  // if name is too long, ERROR
  if(strlen(name) > MAX_NAME_LENGTH) {
    return ERROR;
  }

  // loop to check for ERRORs
  for (int i = 0; i < gradebook.size; i++) {
    //check for duplicate GTID
    if (gradebook.entries[i].student.gtid == gtid) {
      return ERROR;
    }
    // check for duplicate name
    if (strcmp(gradebook.entries[i].student.name, name) == 0) {
      return ERROR; 
    }
  }
  
  // match major (enum) to major (char) and throw ERROR if fake major
  struct GradebookEntry newEntry;
  strcpy(newEntry.student.name, name);
  newEntry.student.gtid = gtid;
  newEntry.student.year = year;
  if (strcmp(major, "CS") == 0) {
    newEntry.student.major = CS;
  } else if (strcmp(major, "CE") == 0) {
    newEntry.student.major = CE;
  } else if (strcmp(major, "EE") == 0) {
    newEntry.student.major = EE;
  } else if (strcmp(major, "IE") == 0) {
    newEntry.student.major = IE;
  } else {
    return ERROR;
  }

  // clear grades
  for(int i = 0; i < NUM_ASSIGNMENTS; i++) {
    newEntry.grades[i] = 0;
  }

  // calculate and set average of newEntry
  calculate_average(&newEntry);

  // update size of gradebook and add entry
  gradebook.entries[gradebook.size++] = newEntry;

  return SUCCESS;
}

/**
 * Updates the grade of a specific assignment for a student and updates that
 * student's average grade.
 * 
 * Ensure that the overall course averages are still up-to-date after these grade updates.
 *
 * @param name The name of the student.
 * @param assignmentType The type of assignment.
 * @param newGrade The new grade.
 * @return SUCCESS if the grade is updated, otherwise ERROR if the grade isn't (student not found).
 */
int update_grade(char* name, enum Assignment assignment_type, double new_grade) {
  // loop through looking for assignment
  for(int i = 0; i < gradebook.size; i++) {
    // if assignment is found, upgrade grade
    if(strcmp(gradebook.entries[i].student.name, name) == 0) {
      // updates grade
      gradebook.entries[i].grades[assignment_type] = new_grade;
      calculate_average(&gradebook.entries[i]);
      calculate_course_average();
      return SUCCESS;
    }
  }
  return ERROR;
}


/**
 * Adds a new student to the gradebook and initializes each of the student's
 * grades with the grades passed in.
 *
 * Additionally, will update the overall assignment_averages and course_average
 * based on the new added student.
 *
 * @param name The name of the student.
 * @param gtid The GTID of the student.
 * @param year The year of the student.
 * @param major The major of the student.
 * @param grades An array of grades for the student.
 * @return SUCCESS if the student is added and the averages updated, otherwise ERROR if the student can't
 * be added (duplicate name / GTID, no space in gradebook, invalid major).
 */
int add_student_with_grades(char *name, int gtid, int year, char *major, double *grades) {
  // do addStudent and determine if it throws ERROR
  int returnVal = add_student(name, gtid, year, major);
  if(returnVal != 0) {
    return ERROR;
  } 

  // Add grades into gradebook
  for(int i = 0; i < NUM_ASSIGNMENTS; i++) {
    gradebook.entries[gradebook.size - 1].grades[i] = grades[i];
  }
  // calculate and set average of grades and determine if it throws ERROR
  returnVal = calculate_average(&gradebook.entries[gradebook.size - 1]);
  if(returnVal != 0) {
    return ERROR;
  } 

  // calculate course average and throw ERROR if necessary
  returnVal = calculate_course_average();
  if(returnVal != 0) {
    return ERROR;
  } 

  return SUCCESS;
}

/**
 * Calculates the average grade for a specific gradebook entry and updates the
 * struct as appropriate.
 *
 * @param entry The gradebook entry for which to recalculate the average.
 * @return SUCCESS if the average is updated, ERROR if pointer is NULL
 */
int calculate_average(struct GradebookEntry *entry) {
  
  // If pointer is null, ERROR
  if (entry == NULL) {
    return ERROR;
  }

  double total_grades = 0;

  // Sum up all grades
  for (int i = 0; i < NUM_ASSIGNMENTS; i++) {
    total_grades += entry->grades[i];
  }
  // Calculate the average
  entry->average = total_grades / NUM_ASSIGNMENTS; // entry.average = total_grades/NUM_ASSIGNMENTS

  return SUCCESS;
}


/**
 * Calculates and update the overall course average and assignment averages. 
 * The average should be calculated by taking the averages of the student's 
 * averages, NOT the assignment averages.
 *
 * If the gradebook is empty, set the course and assignment averages to 0
 * and return ERROR.
 * 
 * @return SUCCESS if the averages are calculated properly, ERROR if gradebook
 * is empty
 */
int calculate_course_average(void) {
  // ERROR if gradebook is empty
  if (gradebook.size == 0) {
    gradebook.course_average = 0;
    for (int i = 0; i < NUM_ASSIGNMENTS; i++) {
      gradebook.assignment_averages[i] = 0;
    }
    return ERROR;
  }

  int overall_average = 0;

  // Calculate the sum of student averages
  for (int i = 0; i < gradebook.size; i++) {
    overall_average += gradebook.entries[i].average;
  }
  // Calculate the course average based on the averages of the student's averages
  gradebook.course_average = overall_average / gradebook.size;

  // Update assignment averages
  for (int i = 0; i < NUM_ASSIGNMENTS; i++) {
    int assignment_average = 0; // Reset assignment_average to 0 for each assignment
    for (int j = 0; j < gradebook.size; j++) {
      assignment_average += gradebook.entries[j].grades[i];
    }
    gradebook.assignment_averages[i] = assignment_average / gradebook.size;
  }

  return SUCCESS;
}



/**
 * Searches for a student in the gradebook by name.
 *
 * @param name The name of the student.
 * @return The index of the student in the gradebook, or ERROR if not found.
 */
int search_student(char* name) {
  // if there is no name, ERROR
  if(name == NULL) {
    return ERROR;
  }

  // iterate through gradebook entries
  for(int i = 0; i < gradebook.size; i++) {
    // if student found, return index
    if(strcmp(gradebook.entries[i].student.name, name) == 0) {
      return i;
    }
  }
  
  // if no student found, ERROR
  return ERROR;
}

/**
 * Remove a student from the gradebook while maintaining the ordering of the gradebook.
 *
 * Additionally, update the overall assignment_averages and course_average
 * based on the removed student and decrement the size of gradebook.
 *
 * If the gradebook is empty afterwards, SUCCESS should still be returned and
 * averages should be set to 0.
 *
 * @param name The name of the student to be withdrawn.
 * @return SUCCESS if the student is successfully removed, otherwise ERROR if
 * the student isn't found.
 */
int withdraw_student(char *name) {
  // if name is null, ERROR
  if(name == NULL) {
    return ERROR;
  }
  
  // obtain index of student and throw ERROR if necessary
  int index = search_student(name);
  if(index == -1) {
    return ERROR;
  }

  // move entries of gradebook
  for(int i = index; i < gradebook.size - 1; i++) {
    gradebook.entries[i] = gradebook.entries[i + 1];
  }
  // decrement gradebook
  gradebook.size--;
  //calculate course average
  calculate_course_average(); 
  return SUCCESS;
}

/**
 * Sorts the gradebook entries by name in alphabetical order (First, Last).
 *
 * @return SUCCESS if names are sorted, ERROR is gradebook is empty.
 */
int sort_name(void) {
  // if gradebook is empty, ERROR
  if(gradebook.size == 0) {
    return ERROR;
  }

  // use bubble sort to sort entries
  for(int i = 0; i < gradebook.size - 1; i++) {
    for(int j = 0; j < gradebook.size - i - 1; j++) {
      if(strcmp(gradebook.entries[j].student.name, gradebook.entries[j + 1].student.name) > 0) {
        struct GradebookEntry temp = gradebook.entries[j];
        gradebook.entries[j] = gradebook.entries[j + 1];
        gradebook.entries[j + 1] = temp;
      }
    }
  }
  return SUCCESS;
}

/**
 * Sorts the gradebook entries by average grades in descending order.
 *
 * @return SUCCESS if entries are sorted, ERROR if gradebook is empty.
 */
int sort_averages(void) {
  // if gradebook is empty, ERROR
  if(gradebook.size == 0) {
    return ERROR;
  }

  // use bubble sort to sort entries
  for(int i = 0; i < gradebook.size; i++) {
    for(int j = 0; j < gradebook.size - i - 1; j++) {
      if(gradebook.entries[j].average < gradebook.entries[j + 1].average) {
        struct GradebookEntry temp = gradebook.entries[j];
        gradebook.entries[j] = gradebook.entries[j + 1];
        gradebook.entries[j + 1] = temp;
      }
    }
  }
  return SUCCESS;
}

/**
 * Populate the provided array with the GTIDs of the 5 students with the highest
 * grades. The GTIDs should be placed in descending order of averages. 
 * 
 * If unable to populate the full array (less than 5 students in gradebook), 
 * fill in the remaining values with INVALID_GTID.
 *
 * @param gtids An array to store the top five gtids.
 * @return SUCCESS if gtids are found, otherwise ERROR if gradebook is empty
 */
int top_five_gtid(int* gtids) {
  // if gradebook is empty, ERROR 
  if(gradebook.size == 0) {
    return ERROR;
  }

  // how many entries are blank
  int filler = (gradebook.size > 4) ? 0 : 5 - gradebook.size;

  // sort entries by averages
  sort_averages();

  // fill the first 5 - filler elements with the top entries
  for(int i = 0; i < 5 - filler; i++) {
    gtids[i] = gradebook.entries[i].student.gtid;
  }

  // fill the rest of the elements with INVALID_GTID
  for(int i = 0; i < filler; i++) {
    gtids[4 - i] = INVALID_GTID;
  }

  return SUCCESS;
}

/**
 * Prints the entire gradebook in the format
 * student_name,major,grade1,grade2,...,student_average\n
 * 
 * Overall Averages:
 * grade1_average,grade2_average,...,course_average\n
 * 
 * Note 1: The '\n' shouldn’t print, just represents the newline for this example.
 * Note 2: There is an empty line above the “Overall Averages:” line.
 * 
 * All of the floats that you print must be manually rounded to 2 decimal places.
 *
 * @return SUCCESS if gradebook is printed, ERROR if gradebook is empty.
 */
int print_gradebook(void) {
  // if gradebook is empty, ERROR
  if(gradebook.size == 0) {
    return ERROR;
  }

  // iterate through gradebook and print entries
  for(int i = 0; i < gradebook.size; i++) {
    printf("%s,%s", gradebook.entries[i].student.name, majorToString(gradebook.entries[i].student.major));
    
    // iterate through student entries and print
    for(int j = 0; j < NUM_ASSIGNMENTS; j++) {
      printf(",%.2f", gradebook.entries[i].grades[j]);
    }

    // print gradebook entries
    printf(",%.2f\n", gradebook.entries[i].average);
  }

  // print formatting
  printf("\nOverall Averages:\n");

  // print assignment averages
  for(int i = 0; i < NUM_ASSIGNMENTS; i++) {
    printf("%.2f,", gradebook.assignment_averages[i]);
  }
  // print course average
  printf("%.2f\n", gradebook.course_average);

  return SUCCESS;
}