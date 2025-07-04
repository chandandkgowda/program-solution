package com.library.service;

import com.library.repository.BookRepository;

// BookService uses Dependency Injection to get BookRepository
public class BookService {
    private BookRepository bookRepository;

    // Setter for Dependency Injection (DI)
    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    public void displayBook() {
        System.out.println("Book Title: " + bookRepository.getBookTitle());
    }
}
