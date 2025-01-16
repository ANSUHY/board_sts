package com.example.demo.dto.file;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileReqDto {
	private int file_no;
	private String origin_file_nm;
	private String save_file_nm;
	private String save_path;
	private String ext;
	private long size;
	private String ref_tbl;
	private int ref_pk;
	private String ref_key;
	private int download_cnt;
	private int ord;
	private Date reg_dt;
}
