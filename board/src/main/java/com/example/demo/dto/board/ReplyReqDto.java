package com.example.demo.dto.board;

import com.example.demo.dto.Paging;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReplyReqDto extends Paging{

	private int reply_no;
	private int board_no;
	private String content;
	private String reply_nm;
	private String reply_password;

}
