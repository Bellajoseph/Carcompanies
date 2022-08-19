import React from "react";
import { useState } from "react";

export const Cars = (props) => {
	const [review, setReview] = useState("");

	return (
		<div className="card-container">
			{props.Cars.map((car) => (
				<div className="col-3" key={car.index}>
					<div className="card">
						<img
							className="card-img-top"
							src={car.image}
							alt="Card cap"
						/>
						<div class="card-body ">
							<h5 class="card-title">Brand: {car.brand}</h5>
							<h6 class="card-subtitle">Model: {car.model}</h6>
							<p class="card-text mt-2">{car.carsAvailable}</p>
							<h5 className="card-title">
								{car.carsAvailable} Cars Available
							</h5>
							<h2>
								Car Price: {car.price / 1000000000000000000}{" "}
								cUSD
							</h2>

							{props.userWallet !== car.owner && (
								<button
									onClick={() => props.likeCar(car.index)}
									class="btn btn-success btn-b"
								>
									Like
								</button>
							)}

							{props.userWallet !== car.owner && (
								<button
									onClick={() => props.dislikeCar(car.index)}
									class="btn btn-dark btn-b"
								>
									Dislike
								</button>
							)}

							{props.userWallet !== car.owner && (
								<small class="int">
									{car.likes} Likes {car.dislikes} Dislikes{" "}
								</small>
							)}

							{props.userWallet !== car.owner && (
								<button
									type="button"
									class="btn btn-primary mt-2"
									onClick={() => props.buyCar(car.index)}
								></button>
							)}

							<form>
								<div class="form-r">
									<input
										type="text"
										class="form-control mt-4"
										value={review}
										onChange={(e) =>
											setReview(e.target.value)
										}
										placeholder="enter review"
									/>
									<button
										type="button"
										onClick={() =>
											props.addReview(car.index, review)
										}
										class="btn btn-dark mt-2"
									>
										Add review
									</button>
									<h5 class="card-title mt-5">Reviews</h5>
									{car.reviews.map((c) => (
										<p class="card-text mt-2" key={c.index}>
											{c.reviewMessage}
										</p>
									))}
									;
								</div>
							</form>
						</div>
					</div>
				</div>
			))}
			;
		</div>
	);
};
export default Cars;
