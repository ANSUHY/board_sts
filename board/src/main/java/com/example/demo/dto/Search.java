package com.example.demo.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Search {

	private String category;
	private String searchType;
	private String keyword;

	private String sort;

}
