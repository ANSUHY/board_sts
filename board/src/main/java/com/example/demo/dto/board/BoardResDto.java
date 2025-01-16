package com.example.demo.dto.board;

import com.example.demo.dto.Search;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardResDto extends Search {

	private int rn;					// ROWNUM
	private int fileCnt;			// 파일 첨부 개수
	private int diffDay;			// 날짜 차이
	private String comm_cd_nm;		// 글 카테고리 명

	private int board_no;			// 게시글 번호
	private String category_cd;		// 카테고리 번호
	private String title;			// 게시글 제목
	private String cont;			// 게시글 내용
	private String writer_nm;		// 게시글 작성자
	private String reg_dt;			// 게시글 등록일

}
