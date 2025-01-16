<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>
		<script type="text/javascript">
			let actionUrl = $("input[name=actionUrl]", opener.document).val();
			let reply_no = $("input[name=reply_no]", opener.document).val();

			console.log(actionUrl);
			console.log(reply_no);

			/*
			$(function() {
				if (reply_no != null || reply_no.length > 0) {
					$("#chkPwd").attr("onclick", "replyPwdChk()");
				}
			});
			*/

			/* 게시글 비밀번호 체크 */
			function chkPwd() {
				$.ajax({
					url: "/chkPwd",
					method: "POST",
					data: {
						board_no : $("input[name=board_no]", opener.document).val(),
						password : $("#password").val()
					},
					success: function (data) {
						if(actionUrl == "/delete") {
							if(confirm("삭제하시겠습니까?")) {
								if (data == true) { // 비밀번호 일치
									getValue();
									alert("삭제되었습니다.");
								} else { // 비밀번호 불일치
									alert("비밀번호가 일치하지 않습니다.");
								}
							}
						} else {
							getValue();
						}
					}
				});
			}

			/* 답글 비밀번호 체크 */
			function replyPwdChk() {
				console.log("reply_no : " + reply_no);
				$.ajax({
					url: "/replyPwdChk",
					method: "GET",
					data: {
						reply_no : reply_no,
						reply_password: $("input[type=password]").val()
					},
					success: function (data) {
						if (data > 0) {
							if (actionUrl == "/delete") {
								deleteReply(reply_no);
							} else {
								getReply(reply_no);
							}
						} else {
							alert("비밀번호가 일치하지 않습니다.");
						}
					},
				});
			}

			/* 값 가져오기 */
			function getValue() {
				$("#detailFrm", opener.document).attr("action", actionUrl); // detail.jsp의 id가 detailFrm의 속성 action을 /edit으로 설정
				$("#detailFrm", opener.document).attr("target", opener.name); // detail.jsp의 id가 detailFrm의 속성 target을 opener.name으로 설정 -> 부모창 submit
				$("#detailFrm", opener.document).attr("method", "post"); // detail.jsp의 id가 detailFrm의 속성 method를 post로 설정
				$("#detailFrm", opener.document).submit(); // submit

				self.close(); // 팝업 닫기
			}

			/* 답글 삭제 */
			function deleteReply(reply_no) {
				opener.deleteReply(reply_no);

				self.close();
			}

			/* 답글을 수정하기 위한 */
			function getReply(reply_no) {
				opener.getReply(reply_no);

				self.close();
			}
		</script>
	</head>

	<body>
		<div id="pop-wrap">
			<h1 class="pop-tit">비밀번호 확인</h1>
			<div class="pop-con">
				<table class="view">
					<colgroup>
						<col style="width: 100px" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" id="password" class="input" style="width: 200px" />
								<a href="javascript:void(0);" id="chkPwd" onclick="chkPwd()" class="btn btn-red">확인</a>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="btn-box">
					<a href="javascript:self.close();" class="btn btn-default">닫기</a>
				</div>
			</div>
			<!-- /pop-con -->
		</div>
		<!-- /pop-wrap -->
	</body>
</html>
