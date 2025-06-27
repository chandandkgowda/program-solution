package com.example;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
}

public class CalculatorTest {

    private Calculator calculator;
    @Before
    public void setUp() {
        System.out.println("Setup: Initializing Calculator object");
        calculator = new Calculator();
    }
    @After
    public void tearDown() {
        System.out.println("Teardown: Cleaning up");
        calculator = null;
    }

    @Test
    public void testAdditionUsingAAA() {
        int a = 10;
        int b = 5;
        int result = calculator.add(a, b);
        assertEquals(15, result);
    }

    @Test
    public void testAdditionWithZeroUsingAAA() {
        int a = 0;
        int b = 7;
        int result = calculator.add(a, b);
        assertEquals(7, result);
    }
}
