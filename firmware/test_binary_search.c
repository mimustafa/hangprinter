#include <stdio.h>
#include <stdlib.h>

int main(int arcg, char** argv){
  double tans[5] = { 0.0, 1.0, 2.0, 3.0, 4.0 };
  double a = strtod(argv[1],NULL);
  printf("got a = %3.2f\n", a);
  int mid   = 2;
  int first = 0;
  int last  = 4;
  int loops = 0;
  do{
    if(loops >= 6){
      printf("fail\n");
      return 1;
    }
    printf("mid = %d\n", mid);
    printf("first = %d\n", first);
    printf("last = %d\n", last);
    fflush(stdout);
    if (a <= tans[mid]){
      last = mid;
      printf("Set last to %d\n", last);
    }else if(first == mid){
        printf("Detected first == mid. Breaking\n");
        break;
    }else{
      first = mid;
      printf("Set first to %d\n", first);
    }
    mid = (first + last) >> 1;
    printf("Set mid to %d\n", mid);
    loops++;
    printf("first = %d\n", first);
    printf("last = %d\n", last);
    printf("The check last != first returns %d\n", last != first);
    printf("\n");
  } while(last != first);

  printf("i = %d\n", mid+1);

  /* This search is linear, could be made binary */
  int i;
  for(i=1; i < 5; i++){
    if(a <= tans[i]){
      break;
    }
  }
  printf("Correct answer: %d\n", i);

  return 0;

}
