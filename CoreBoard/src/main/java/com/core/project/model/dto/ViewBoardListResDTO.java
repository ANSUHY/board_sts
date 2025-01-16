package com.core.project.model.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class ViewBoardListResDTO {

	/** 게시글 no - row_num */
	private int row_num;
	/** 게시글 번호 */
	private int board_no;
	/** 카테고리 코드 */
	private String category_cd;
	/** 제목 */
	private String title;
	/** 내용 */
	private String cont;
	/** 작성자명 */
	private String writer_nm;
	/** 비밀번호 */
	private String password;
	/** 조회수 */
	private int view_cnt;
	/**등록일시 */
	private Date reg_dt;
	/** 수정일시 */
	private Date mod_dt;
	/** +카테고리명 */
	private String comm_cd_nm;
	/** +3일이내 게시글 구분을 위한 변수 */
	private int new_icon;
	/** file개수 */
	private String file_count;

}
