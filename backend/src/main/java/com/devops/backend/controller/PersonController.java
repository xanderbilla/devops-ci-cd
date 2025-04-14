package com.devops.backend.controller;

import com.devops.backend.dto.PersonDTO;
import com.devops.backend.model.Person;
import com.devops.backend.repository.PersonRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/persons")
public class PersonController {

    private final PersonRepository personRepository;

    public PersonController(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }

    @PostMapping
    public ResponseEntity<PersonDTO> createPerson(@RequestBody PersonDTO personDTO) {
        Person person = new Person(personDTO.getName(), personDTO.getAge());
        Person savedPerson = personRepository.save(person);
        return ResponseEntity.ok(new PersonDTO(savedPerson.getName(), savedPerson.getAge()));
    }

    @GetMapping
    public ResponseEntity<List<PersonDTO>> getAllPersons() {
        List<PersonDTO> persons = personRepository.findAll().stream()
                .map(person -> new PersonDTO(person.getName(), person.getAge()))
                .collect(Collectors.toList());
        return ResponseEntity.ok(persons);
    }
}