<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="ko">
	<head>
		<!-- head -->
		<%@include file="../layout/head.jsp" %>
		<!--// head -->

		<script>

			$(document).ready(function(){

				let board_no = $("#board_no").val();

				$.ajax({

					type    : 'POST',
					url     :  "/board/getBoardDetail",
					data	: 	{ "board_no" : board_no },
					success : function(result) {

							$("#writer_nm").html(result.writer_nm);
							$("#reg_dt").html(result.reg_dt);
							$("#title").html(result.title);
							$("#cont").html(result.cont);
							$("#comm_cd_nm").html(result.comm_cd_nm);
							$("#password").html(result.password);

					},
					error   : function(error, xhr) {
						console.log(xhr, error);
					}
				});
			});


			function openPopup() {

				let url = "/board/passwordPopUp";
				let name = "passwordPopUp"
				let option = "toolbar=no, memubar=no, scrollbars=no, resizable=no, width=700, height=400" ;

				window.open(url, name, option);
			}

		</script>
	</head>

	<body>

		<div id="wrap">

			<!-- header -->
			<%@include file="../layout/header.jsp" %>
			<!--// header -->

			<!-- container -->
			<div id="container">

				<!-- left -->
				<%@include file="../layout/left.jsp" %>
				<!--// left -->

				<!-- contents -->
				<div id="contents">

					<div class="location">
						<span class="ic-home">HOME</span><span>커뮤니티</span><em>통합게시판</em>
					</div>

					<div class="tit-area">
						<h3 class="h3-tit">통합게시판</h3>
					</div>

					<form name="search-form" id="search-form" method="post" onsubmit="return false;">
						<input type="hidden" name="type"		id="type"		value="${searchData.type}"/>
						<input type="hidden" name="keyword"		id="keyword"	value="${searchData.keyword}"/>
						<input type="hidden" name="category"	id="category"	value="${searchData.category}"/>
						<input type="hidden" name="orderData"	id="orderData"	value="${searchData.orderData}"/>
						<input type="hidden" name="curPage"		id="curPage"	value="${searchData.curPage}"/>
						<input type="hidden" name="sizePage"	id="sizePage"	value="${searchData.sizePage}"/>
					</form>

					<input type="hidden" name="board_no" id="board_no"	value="${searchData.board_no}"/> <!-- 여기에다가 board_no 담아서 보내보기 -->

					<form name="board-form" id="board-form" method="post"> <!-- 폼태그 -->
						<table class="write">
						<colgroup>
							<col style="width:150px;">
							<col>
							<col style="width:150px;">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th class="fir">작성자</th>
							<td id="writer_nm"><!-- vvvvvvv --></td>
							<th class="fir">작성일시</th>
							<td id="reg_dt"><!-- vvvvvvv --></td>
						</tr>
						<tr>
							<th class="fir">카테고리</th>
							<td colspan="3" id="comm_cd_nm"><!-- vvvvvvvvvvv --></td>
						</tr>
						<tr>
							<th class="fir">제목</th>
							<td colspan="3" id="title"><!-- vvvvvvv --></td>
						</tr>
						<tr>
							<th class="fir">내용</th>
							<td colspan="3" id="cont">
									<!-- vvvvvvvvvv -->
							</td>
						</tr>
						<!--
						<tr>
							<th class="fir">첨부파일</th>
							<td colspan="3">
								<span><a href="#">상담내역1.xlsx</a></span>
								<br />
								<span><a href="#">상담내역2.xlsx</a></span>
							</td>
						</tr>
						-->
						</tbody>
						</table>
					</form>

					<div class="btn-box r">
						<a href="#" class="btn btn-green" onclick="openPopup()">수정</a>
						<a href="#" class="btn btn-red" onclick="openPopup()">삭제</a>
						<a href="#" class="btn btn-default" onclick="openPopup()">목록</a>
					</div>

				</div><!-- /contents -->

			</div><!-- /container -->

			<!-- right -->
			<%@include file="../layout/right.jsp" %>
			<!--// right -->

			<!-- footer -->
			<%@include file="../layout/footer.jsp" %>
			<!--// footer -->

		</div><!-- /wrap -->

		<script>
			gnb('1','1');
		</script>

	</body>
</html>