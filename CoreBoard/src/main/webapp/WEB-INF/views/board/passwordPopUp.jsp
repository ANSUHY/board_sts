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

				var boardNum = opener.$("#board_no").val();
				$("#board_no").val(boardNum);

			})

			function checkPassword() {

				let password = $("#password").val();
				let boardNum = $("#board_no").val();

				$.ajax({

					url 	: '/board/findPassword',
					type 	: 'post',
					data	: {
						'boardNum' : boardNum,
						'password' : password
					},
					success	: function (result) {
							if( result == true) {
								window.close();
								window.opener.location.href="/board/updateBoard";
							} else {
								alert("비밀번호가 틀렸습니다.");
							}
					},
					error	: function(error, xhr) {
						console.log(xhr);
					}

				});

			}
		</script>

	</head>

	<body>

		<div id="pop-wrap">
			<h1 class="pop-tit">비밀번호 확인</h1>
			<div class="pop-con">

				<table class="view">
				<colgroup>
				<col style="width:100px;"><col>
				</colgroup>
				<tbody id="area">
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="hidden" name="board_no" id="board_no" value=""/>
						<input type="password" class="input" name="password" id="password" style="width:200px;">
						<a href="#" class="btn btn-red" onclick="checkPassword()">확인</a>
					</td>
				</tr>
				</tbody>
				</table>

				<div class="btn-box">
					<a href="javascript:self.close();" class="btn btn-default">닫기</a>
				</div>

			</div><!-- /pop-con -->
		</div><!-- /pop-wrap -->

	</body>
</html>