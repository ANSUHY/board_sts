package com.example.demo.dto.board;

import com.example.demo.dto.Paging;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReplyResDto extends Paging {

	private int rn;

	private int reply_no;
	private String content;
	private String reply_nm;
	private String indate;

}
