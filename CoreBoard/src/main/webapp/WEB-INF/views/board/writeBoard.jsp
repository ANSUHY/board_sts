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

			/* 게시글 등록을 위한 ajax */
			function insertBoard() {

					let answer = confirm("저장하시겠습니까?");

					let category_cd = $("select[name=category_cd] option:selected").val();
					let title = $("#title").val();
					let cont = $("#cont").val();
					let writer_nm = $("#writer_nm").val();
					let password = $("#password").val();


					let data = {
							'category_cd' 	: category_cd,
							'title'			: title,
							'cont'			: cont,
							'writer_nm'		: writer_nm,
							'password'		: password

					}

					if(answer == true) {
						$.ajax({

							type 		: 'POST',
							url  		: '/board/insertBoard', //가게
							dataType 	: 'json',
							data		:  data,    //돈 $("form[name=write-form]").serialize(),

							success		: function(data) {
								alert("저장 되었습니다.");
							},

							error		: function(xhr) {
								alert("등록 실패")
								console.log(xhr);
								console.log(data);
							}

						});
					}

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

				<!-- <form name="write-form" id="write-form" method="post"> -->
						<table class="write">
						<colgroup>
							<col style="width:150px;">
							<col>
							<col style="width:150px;">
							<col>
						</colgroup>
						<tbody>
						<tr>
							<th class="fir">작성자 <i class="req">*</i></th>
							<td><input type="text" class="input block" name="writer_nm" id="writer_nm"></td> 			<!-- 작성자 -->
							<th class="fir">비밀번호 <i class="req">*</i></th>
							<td><input type="password" class="input block" name="password" id="password"></td> <!-- 비밀번호 -->
						</tr>
						<tr>
							<th class="fir">카테고리 <i class="req">*</i></th>
							<td colspan="3">
								<select class="select" name="category_cd" style="width:150px;">
									<c:forEach var="categoryList" items="${categoryList}">
									<option value="${ categoryList.category_cd }" >${ categoryList.comm_cd_nm }</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="fir">제목 <i class="req">*</i></th>
							<td colspan="3">
								<input type="text" class="input" name="title" id="title" style="width:100%;"> <!-- 제목 -->
							</td>
						</tr>
						<tr>
							<th class="fir">내용 <i class="req">*</i></th>
							<td colspan="3"> <!-- 컨텐츠 -->
								<textarea name="cont" id="cont" style="width:100%; height:300px;">
								</textarea>
							</td>
						</tr>
						<!--
						<tr>
							<th class="fir">첨부파일 1 <i class="req">*</i></th>
							<td colspan="3">
								<span><a href="#">상담내역1.xlsx</a> <a href="#" class="ic-del">삭제</a></span>
								<br />
								<input type="file" class="input block mt10">
							</td>
						</tr>
						<tr>
							<th class="fir">첨부파일 2</th>
							<td colspan="3">
								<span><a href="#">상담내역2.xlsx</a> <a href="#" class="ic-del">삭제</a></span>
								<br />
								<input type="file" class="input block mt10">
							</td>
						</tr>
						<tr>
							<th class="fir">첨부파일 3</th>
							<td colspan="3">
								<input type="file" class="input block mt10">
							</td>
						</tr>
						-->
						</tbody>
						</table>
			<!-- 	</form> -->

					<div class="btn-box r">
						<a href="#" class="btn btn-red" onclick="insertBoard()">저장</a>
						<a href="javascript:history.back();" class="btn btn-default">취소</a>
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