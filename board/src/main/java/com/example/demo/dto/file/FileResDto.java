package com.example.demo.dto.file;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileResDto {
	private int file_no;
	private String origin_file_nm;
	private String save_file_nm;
	private String save_path;
	private int ord;
}
