
create table bt_tb_board
(
	board_no              int auto_increment not null comment '게시물번호',
	category_cd           varchar(30) null comment '카테고리코드',
	title                 varchar(200) not null comment '제목',
	cont                  text null comment '내용',
	writer_nm             varchar(50) not null comment '작성자명',
	password              varchar(100) not null comment '비밀번호',
	view_cnt              int null comment '조회수',
	reg_dt                datetime not null comment '등록일시',
	mod_dt                datetime null comment '수정일시',
	primary key (board_no)
) comment = '게시물'
;

create table bt_tb_gruop_code
(
	grp_cd                varchar(30) not null comment '그룹코드',
	grp_cd_nm             varchar(50) not null comment '그룹코드명',
	reg_dt                datetime not null comment '등록일시',
	primary key (grp_cd)
) comment = '그룹코드'
;

create table bt_tb_comm_code
(
	grp_cd                varchar(30) not null comment '그룹코드',
	comm_cd               varchar(30) not null comment '공통코드',
	comm_cd_nm            varchar(50) not null comment '공통코드명',
	comm_cd_val           varchar(100) not null comment '공통코드값',
	add1                  varchar(50) null comment '추가1',
	add2                  varchar(50) null comment '추가2',
	add3                  varchar(50) null comment '추가3',
	ord                   int null comment '순서',
	del_yn                varchar(1) not null comment '삭제여부',
	reg_dt                datetime not null comment '등록일시',
	primary key (grp_cd,comm_cd),
	foreign key fk_comm_code_01 (grp_cd) references bt_tb_gruop_code(grp_cd)
) comment = '공통코드'
;

create table bt_tb_file
(
	file_no               int auto_increment not null comment '파일번호',
	origin_file_nm        varchar(50) not null comment '원본파일명',
	save_file_nm          varchar(50) not null comment '저장파일명',
	save_path             varchar(100) not null comment '저장경로',
	ext                   varchar(30) not null comment '확장자',
	size                  int not null comment '사이즈',
	ref_tbl               varchar(50) null comment '참조테이블',
	ref_pk                varchar(50) null comment '참조pk',
	ref_key               varchar(50) null comment '구분키',
	download_cnt          int not null comment '다운로드수',
	ord                   int null comment '순서',
	reg_dt                datetime not NULL comment '등록일시',
	primary key (file_no)
) comment = '파일'
;

create table bt_tb_reply
(
	reply_no              int not null auto_increment not null comment '댓글번호',
	board_no        	  int not null comment '게시물번호',
	content          	  text not null comment '내용',
	reply_nm              varchar(50) not null comment '작성자명',
	reply_password        varchar(100) not null comment '비밀번호',
	indate                datetime not NULL comment '등록일시',
	primary key (reply_no)
) comment = '댓글'
;

INSERT INTO bt_tb_gruop_code (grp_cd, grp_cd_nm, reg_dt) VALUES('CTG', '카테고리', now());

INSERT INTO bt_tb_comm_code (grp_cd, comm_cd, comm_cd_nm, comm_cd_val, ord, del_yn, reg_dt) VALUES('CTG', 'CTG001', '공지', 'notice', 1, 'N', now());
INSERT INTO bt_tb_comm_code (grp_cd, comm_cd, comm_cd_nm, comm_cd_val, ord, del_yn, reg_dt) VALUES('CTG', 'CTG002', '중요', 'important', 2, 'N', now());
INSERT INTO bt_tb_comm_code (grp_cd, comm_cd, comm_cd_nm, comm_cd_val, ord, del_yn, reg_dt) VALUES('CTG', 'CTG003', '일반', 'normal', 3, 'N', now());




