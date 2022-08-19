import React from "react";
import { useState } from "react";

export const AddCar = (props) => {
	const [brand, setBrand] = useState("");
	const [model, setModel] = useState("");
	const [image, setImage] = useState("");
	const [price, setPrice] = useState("");
	const [carsAvailable, setCarsAvailable] = useState("");

	return (
		<div className="mt-5 container">
			<h4 className="text-start fs-4">Add Car</h4>
      <form className="">
				<div class="form-row">
					<input
						type="text"
						class="form-control"
						value={brand}
						onChange={(e) => setBrand(e.target.value)}
						placeholder="Car Brand"
					/>

					<input
						type="text"
						class="form-control mt-2"
						value={model}
						onChange={(e) => setModel(e.target.value)}
						placeholder="Car Model"
					/>

					<input
						type="text"
						class="form-control mt-2"
						value={image}
						onChange={(e) => setImage(e.target.value)}
						placeholder="Image url"
					/>

					<input
						type="text"
						class="form-control mt-2"
						value={price}
						onChange={(e) => setPrice(e.target.value)}
						placeholder="Price"
					/>

					<input
						type="text"
						class="form-control mt-2"
						value={carsAvailable}
						onChange={(e) => setCarsAvailable(e.target.value)}
						placeholder="Number of Cars Available"
					/>

					<button
						type="button"
						onClick={() =>
							props.addCar(
								brand,
								model,
								image,
								price,
								carsAvailable
							)
						}
						class="btn btn-dark mt-2"
					>
						Add Car
					</button>
				</div>
			</form>
		</div>
	);
};
export default AddCar;
