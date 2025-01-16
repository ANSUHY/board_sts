package com.example.demo.dto.board;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardDto {

	private int rn;
	private int fileCnt;
	private int board_no;
	private String category_cd;
	private String title;
	private String cont;
	private String writer_nm;
	private String password;
	private int view_cnt;
	private String reg_dt;
	private String mod_dt;

	// 글 카테고리 명
	private String comm_cd_nm;

	// 현재 날짜 - 등록 날짜
	private int diffDay;

	// 댓글 개수
	private int replyCnt;

}
