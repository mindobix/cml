#include <criterion/criterion.h>
#include "../src/learn/static.h"

Test(static_tests, static_count_success) {
    int i = staticCount(1);
    cr_expect(i == 0, "static_tests::static_count_success failed"); 

}